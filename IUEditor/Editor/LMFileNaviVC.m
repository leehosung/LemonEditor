//
//  LMFileNaviVC.m
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMFileNaviVC.h"
#import "IUSheetGroup.h"
#import "IUResourceFile.h"
#import "NSTreeController+JDExtension.h"
#import "IUPage.h"
#import "IUBackground.h"
#import "IUClass.h"
#import "LMWC.h"
#import "IUProject.h"

@interface LMFileNaviVC ()
@property (weak) IBOutlet NSOutlineView *outlineV;
@end

@implementation LMFileNaviVC{
    BOOL    viewLoadedOK;
    BOOL    loaded;
    id      _lastClickedItem;
    NSArray *_draggingIndexPaths;
    IUSheet  *_draggingItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}
-(void)awakeFromNib{
    [_outlineV registerForDraggedTypes:@[@"IUFileNavi"]];
}

- (void)setDocumentController:(IUSheetController *)documentController{
    _documentController = documentController;
    [_documentController addObserver:self forKeyPath:@"selection" options:0 context:nil];
    [_documentController bind:NSContentBinding toObject:self withKeyPath:@"project" options:nil];
}

-(void)dealloc{
    //release 시점 확인용
    NSAssert(0, @"dealloc");
    //[_documentController removeObserver:self forKeyPath:@"selection"];
}

#pragma mark -selection

-(void)selectionIndexPathsDidChange{
    JDTraceLog( @"selection");
}

-(void)selectionDidChange:(NSDictionary*)dict{
    [self willChangeValueForKey:@"selection"];
    _selection = [_documentController.selectedObjects firstObject];
    [self didChangeValueForKey:@"selection"];
}

-(void)selectFirstDocument{
    //find first document
    [_documentController setSelectedObject:_project.pageDocuments.firstObject];
}


#pragma mark - outlineView

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode*)item {
    //folder
    if ( [item.representedObject isKindOfClass:[IUProject class]] ||
        [item.representedObject isKindOfClass:[IUResourceGroup class]]){
        
        IUSheetGroup *doc = (IUSheetGroup*) item.representedObject;
        NSTableCellView *folder = [outlineView makeViewWithIdentifier:@"folderNoAdd" owner:self];
        [folder.textField setStringValue:doc.name];
        
        return folder;
    }
    else if ([item.representedObject isKindOfClass:[IUSheetGroup class]])
    {
        NSTableCellView *folder;
        
        IUSheetGroup *doc = (IUSheetGroup*) item.representedObject;
        if ([doc isKindOfClass:[IUSheetGroup class]]) {
            
            if ([doc.name isEqualToString:IUBackgroundGroupName]) {
                folder = [outlineView makeViewWithIdentifier:@"folderNoAdd" owner:self];
            }
            else{
                folder = [outlineView makeViewWithIdentifier:@"folder" owner:self];

            }
        }
    
        [folder.textField setStringValue:doc.name];
        
        return folder;
    }
    //file
    else{
        NSString *cellIdentifier, *nodeName;
        if ([[item representedObject] isKindOfClass:[IUSheet class]]){
            IUSheet *node = [item representedObject];
            if([node.group.name isEqualToString:IUPageGroupName]){
                cellIdentifier = @"pageFile";
            }
            else if([node.group.name isEqualToString:IUBackgroundGroupName]){
                cellIdentifier = @"backgroundFile";
            }
            else if ([node.group.name isEqualToString:IUClassGroupName]){
                cellIdentifier = @"classFile";
            }
            else {
                NSAssert(0, @"");
            }
            nodeName = node.name;
        }
        else if( [[item representedObject] isKindOfClass:[IUResourceFile class]] ){
            IUResourceFile *node = [item representedObject];
            
            if( node.type == IUResourceTypeImage ){
                cellIdentifier = @"imageFile";
            }
            else if(node.type == IUResourceTypeVideo){
                cellIdentifier = @"videoFile";
            }
            else if(node.type == IUResourceTypeCSS){
                cellIdentifier = @"cssFile";
            }
            else if(node.type == IUResourceTypeJS){
                cellIdentifier = @"JSFile";
            }
            else {
                NSAssert(0, @"");
            }
            nodeName = node.name;
        }
        
        NSTableCellView *cell = [outlineView makeViewWithIdentifier:cellIdentifier owner:self];
        [cell.textField setStringValue:nodeName];

        return cell;
    }
    return nil;
}

#pragma mark -

- (IBAction)outlineViewClicked:(NSOutlineView *)sender{
    NSTreeNode* clickItem = [sender itemAtRow:[sender clickedRow]];
    BOOL extended = [sender isItemExpanded:clickItem];
    
    if (extended == NO) {
        [sender.animator expandItem:clickItem];
    }
    else if ( _lastClickedItem == clickItem){
        [sender.animator collapseItem:clickItem];
    }
    _lastClickedItem = clickItem;
}


#pragma mark -
#pragma mark rightmenu


- (NSMenu *)defaultMenuForRow:(NSInteger)row{
    NSTreeNode *item = [_outlineV itemAtRow:row];
    id node = [item representedObject];

    if( [node isKindOfClass:[IUSheet class]]){
        NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Document"];
        NSMenuItem *openItem = [[NSMenuItem alloc] initWithTitle:@"Show in Finder" action:@selector(openProject:) keyEquivalent:@""];
        openItem.tag = row;
        openItem.target = self;
        [menu addItem:openItem];
        

        NSMenuItem *removeItem = [[NSMenuItem alloc] initWithTitle:@"Remove Document" action:@selector(removeDocument:) keyEquivalent:@""];
        removeItem.tag = row;
        removeItem.target = self;
        [menu addItem:removeItem];
        
        if([node isKindOfClass:[IUClass class]]){
            NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:@"Copy Document" action:@selector(copyDocument:) keyEquivalent:@""];
            copyItem.tag = row;
            copyItem.target = self;
            [menu addItem:copyItem];
        }


        return menu;
    }

    else {
    }
    return nil;
    
}


- (void)openProject:(id)sender {
    [[NSWorkspace sharedWorkspace] openFile:_project.directoryPath];
}

- (void)copyDocument:(NSMenuItem*)sender{
    NSTreeNode *item = [_outlineV itemAtRow:sender.tag];
    IUSheet * node = [item representedObject];
    IUSheet * newNode = [node copy];
    [self.project addSheet:newNode toSheetGroup:node.group];
    [self.project.identifierManager registerIUs:@[newNode]];
    [self.documentController rearrangeObjects];
}

- (void)removeDocument:(NSMenuItem*)sender{
    NSTreeNode *item = [_outlineV itemAtRow:sender.tag];
    IUSheet * node = [item representedObject];
    if (node.group.childrenFiles.count == 1) {
        NSBeep();
        [JDUIUtil hudAlert:@"Each document folder should have at least one document" second:2];
        return;
    }
    [self.project removeSheet:node toSheetGroup:node.group];
    [self.project.identifierManager unregisterIUs:@[node]];
    [_documentController rearrangeObjects];
}


#pragma mark - cell specivfic action (add, name editing)

- (IBAction)pressAddBtn:(id)sender{
    if([sender isKindOfClass:[NSButton class]]){
        
        NSTableCellView *cellView = (NSTableCellView *)[sender superview];
        NSString *groupName =  cellView.textField.stringValue;
        IUSheet *newDoc;
        [[self.project identifierManager] resetUnconfirmedIUs];
        if([groupName isEqualToString:IUPageGroupName]){
            
            newDoc = [[IUPage alloc] initWithProject:self.project options:nil];
            [self.project addSheet:newDoc toSheetGroup:self.project.pageGroup];
            [self.project.identifierManager registerIUs:@[newDoc]];
            IUBackground *defaultBG = self.project.backgroundDocuments[0];
            [(IUPage*)newDoc setBackground:defaultBG];
        }
        else if([groupName isEqualToString:IUClassGroupName]){
            newDoc = [[IUClass alloc] initWithProject:self.project options:nil];
            [self.project addSheet:newDoc toSheetGroup:self.project.classGroup];
            [self.project.identifierManager registerIUs:@[newDoc]];
        }
        
        if(newDoc){
            [self.documentController rearrangeObjects];
            [self.documentController setSelectedObject:newDoc];
        }
        [[self.project identifierManager] confirm];
    }
}



- (IBAction)fileNameEndEditing:(id)sender{
    NSAssert(_project.identifierManager, @"");
    
    NSTextField *textField = (NSTextField *)sender;
    
    IUSheet *sheet = (IUSheet *)self.selection;
    NSString *modifiedName = textField.stringValue;
    
    if([modifiedName isEqualToString:sheet.name]){
        [textField setStringValue:sheet.name];
        return;
    }
    
    if(modifiedName.length == 0){
        [JDUIUtil hudAlert:@"Name should not be empty" second:2];
        [textField setStringValue:sheet.name];
        return;
    }
    
    if([definedIdentifers containsString:modifiedName]
       || [definedPrefixIdentifiers containsPrefix:modifiedName]){
        [JDUIUtil hudAlert:@"This name is a program keyword" second:2];
        [textField setStringValue:sheet.name];
        return;
    }
    
    NSCharacterSet *characterSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    if([modifiedName rangeOfCharacterFromSet:characterSet].location != NSNotFound){
        [JDUIUtil hudAlert:@"Name should be alphabet or digit" second:2];
        [textField setStringValue:sheet.name];
        return;
    }
    
    IUBox *box = [_project.identifierManager IUWithIdentifier:modifiedName];
    if (box != nil) {
        [JDUIUtil hudAlert:@"IU with same name exists" second:1];
        [textField setStringValue:sheet.name];
        return;
    }
    
    [_project.identifierManager unregisterIUs:@[sheet]];
    sheet.htmlID = modifiedName;
    [_project.identifierManager registerIUs:@[sheet]];
    sheet.name = modifiedName;
    
    
}

#pragma mark -
#pragma mark drag and drop
- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard{
    id item = [items firstObject];
    if ([[item representedObject] isKindOfClass:[IUSheet class]]){
        [pboard declareTypes:@[@"IUFileNavi"] owner:self];
        _draggingIndexPaths = [_documentController selectionIndexPaths];
        _draggingItem = [[_documentController selectedObjects] firstObject];
        return YES;
    }
    return NO;
}

- (NSDragOperation)outlineView:(NSOutlineView *)ov validateDrop:(id <NSDraggingInfo>)info proposedItem:(NSTreeNode*)item proposedChildIndex:(NSInteger)childIndex {
    id itemRepresented = [item representedObject];
    if ([itemRepresented isKindOfClass:[IUSheetGroup class]]) {
        if ((IUSheetGroup*)itemRepresented == [_draggingItem group] ) {
            return NSDragOperationMove;
        }
    }
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index{
    //rearrange
    IUSheetGroup *group = [item representedObject];
    NSIndexPath *originalIndexPath = [_draggingIndexPaths lastObject];
    NSInteger lastIndexPath = [originalIndexPath indexAtPosition:originalIndexPath.length-1];
    if (index > lastIndexPath) {
        index --;
    }
    [group changeIndex:_draggingItem toIndex:index];
    [_documentController rearrangeObjects];
    return YES;
}


@end
