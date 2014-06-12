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
#import "LMFileNaviCellView.h"

@interface LMFileNaviVC ()

@property (weak) IBOutlet JDOutlineView *navOutlineView;

@end

@implementation LMFileNaviVC{
    BOOL    viewLoadedOK;
    BOOL    loaded;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)awakeFromNib{
    [_documentController addObserver:self forKeyPath:@"selection" options:0 context:nil];
    [_documentController bind:NSContentBinding toObject:self withKeyPath:@"project" options:nil];  
}

-(void)dealloc{
    //release 시점 확인용
    assert(0);
    //[_documentController removeObserver:self forKeyPath:@"selection"];
}

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

- (void)pressAddBtn:(NSButton*)sender{
    IUSheet *newDoc;
    switch (sender.tag) {
        case 1:{
            newDoc = [[IUPage alloc] initWithProject:self.project options:nil];
            [self.project.pageGroup addSheet:newDoc];
            [self.project.identifierManager registerIUs:@[newDoc]];
            IUBackground *defaultBG = self.project.backgroundDocuments[0];
            [(IUPage*)newDoc setBackground:defaultBG];
        }
            break;
        case 2:{
            assert(0);
        }
            break;
        case 3:{
            newDoc = [[IUClass alloc] initWithProject:self.project options:nil];
            [self.project.classGroup addSheet:newDoc];
        }
            break;
            
        default:
            assert(0);
            break;
    }
    [self.documentController rearrangeObjects];
    [self.documentController setSelectedObject:newDoc];
}


- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode*)item {
    //folder
    if ( [item.representedObject isKindOfClass:[IUProject class]] ||
        [item.representedObject isKindOfClass:[IUSheetGroup class]] ||
        [item.representedObject isKindOfClass:[IUResourceGroup class]]){
        LMFileNaviCellView *folder = [outlineView makeViewWithIdentifier:@"folder" owner:self];
        
        IUSheetGroup *doc = (IUSheetGroup*) item.representedObject;
        if ([doc isKindOfClass:[IUSheetGroup class]]) {
            [folder.addButton setHidden:NO];
            if ([doc.name isEqualToString:@"Pages"]) {
                folder.addButton.tag = 1;
            }
            else if ([doc.name isEqualToString:@"Backgrounds"]) {
                [folder.addButton setHidden:YES];
            }
            else if ([doc.name isEqualToString:@"Classes"]) {
                folder.addButton.tag = 3;
            }
            else {
                assert(0);
            }
            [folder.addButton setTarget:self];
            [folder.addButton setAction:@selector(pressAddBtn:)];
        }
        else {
            [folder.addButton setHidden:YES];
        }
        return folder;
    }
    //file
    else{
        NSString *cellIdentifier;
        if ([[item representedObject] isKindOfClass:[IUSheet class]]){
            IUSheet *node = [item representedObject];
            if([node.group.name isEqualToString:@"Pages"]){
                cellIdentifier = @"pageFile";
            }
            else if([node.group.name isEqualToString:@"Backgrounds"]){
                cellIdentifier = @"backgroundFile";
            }
            else if ([node.group.name isEqualToString:@"Classes"]){
                cellIdentifier = @"classFile";
            }
            assert(cellIdentifier);
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
        }
        assert(cellIdentifier != nil);
        
        LMFileNaviCellView *cell = [outlineView makeViewWithIdentifier:cellIdentifier owner:self];
        cell.project = _documentController.project;
        return cell;
    }
    return nil;
}

#pragma mark -
#pragma mark rightmenu
- (NSMenu *)defaultMenuForRow:(NSInteger)row{
    NSTreeNode *item = [_navOutlineView itemAtRow:row];
    id node = [item representedObject];

    if( [node isKindOfClass:[IUSheet class]]){
        NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Document"];
        NSMenuItem *openItem = [[NSMenuItem alloc] initWithTitle:@"Open Project Folder" action:@selector(openProject:) keyEquivalent:@""];
        openItem.tag = row;
        openItem.target = self;

        NSMenuItem *removeItem = [[NSMenuItem alloc] initWithTitle:@"Remove Document" action:@selector(removeDocument:) keyEquivalent:@""];
        removeItem.tag = row;
        removeItem.target = self;
        
        NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:@"Copy Document" action:@selector(copyDocument:) keyEquivalent:@""];
        copyItem.tag = row;
        copyItem.target = self;
        
        [menu addItem:openItem];
        [menu addItem:removeItem];

        [menu addItem:copyItem];
        return menu;
    }

    else {
    }
    return nil;
    
}

- (IBAction)clickShowInFinder:(id)sender {
    NSURL *url = [NSURL fileURLWithPath:_project.path];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[url]];
    
}

- (void)copyDocument:(NSMenuItem*)sender{
    NSTreeNode *item = [_navOutlineView itemAtRow:sender.tag];
    IUSheet * node = [item representedObject];
    IUSheet * newNode = [node copy];
    [node.group addSheet:newNode];
    [self.documentController rearrangeObjects];
}


- (void)removeDocument:(NSMenuItem*)sender{
    NSTreeNode *item = [_navOutlineView itemAtRow:sender.tag];
    IUSheet * node = [item representedObject];
    if (node.group.childrenFiles.count == 1) {
        NSBeep();
        [JDUIUtil hudAlert:@"Each document folder should have at least one document" second:2];
        return;
    }
    [node.group removeSheet:node];
    [_documentController rearrangeObjects];
}

- (IBAction)clickMenuAddFile:(id)sender {
    assert(0);
    /*
    NSTreeNode *node = [_navOutlineView itemAtRow:_navOutlineView.rightClickedIndex];
    IUGroupNode *groupNode;
    if([self isFolder:node]){
        groupNode = [node representedObject];
    }
    else{
        groupNode = [node.parentNode representedObject];
    }
    
    if([groupNode isKindOfClass:[IUDocumentGroupNode class]]){
        NSString *className;
        if([groupNode.name isEqualToString:@"Pages"]){
            className = @"IUPage";
        }
        else if([groupNode.name isEqualToString:@"Backgrounds"]){
            className = @"IUBackground";
        }
        else if ([groupNode.name isEqualToString:@"Classes"]){
            className = @"IUClass";
        }
        
        IUBox *obj = [[NSClassFromString(className) alloc] initWithIdentifierManager:_identifierManager option:nil];
        if (obj == nil) {
            assert(0);
        }
        
        [_identifierManager setNewIdentifierAndRegisterToTemp:obj withKey:nil];
        obj.name = obj.htmlID;
        
        
        if ([obj isKindOfClass:[IUPage class]]) {
            IUBackground *bg = [[_documentController.project backgroundDocuments] firstObject];
            [(IUPage*)obj setBackground:bg];
        }
        
        IUDocumentGroup *fileNode = [[IUDocumentGroup alloc] init];
        fileNode.document = obj;
        fileNode.name = obj.name;
        
        [groupNode addNode:fileNode];

        [fileNode.document setIdentifierManager:_identifierManager];
        [_identifierManager registerIU:obj];
    }
     */
}

- (void)openProject:(id)sender {
    [[NSWorkspace sharedWorkspace] openFile:_project.directoryPath];
}

- (BOOL)keyDown:(NSEvent *)event{
    if (event.keyCode == 36) { // enter key

        LMFileNaviCellView *cell = [self.navOutlineView selectedView];
        [cell.textField setEditable:YES];
        [self.navOutlineView.window makeFirstResponder:cell.textField];
        
    }
    return YES;
}
@end
