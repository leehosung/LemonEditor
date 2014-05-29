//
//  LMFileNaviVC.m
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMFileNaviVC.h"
#import "IUDocumentGroup.h"
#import "IUResourceFile.h"
#import "NSTreeController+JDExtension.h"
#import "IUPage.h"
#import "IUBackground.h"
#import "IUClass.h"
#import "LMWC.h"
#import "LMFileNaviCellView.h"

@interface LMFileNaviVC ()

@property (weak) IBOutlet JDOutlineView *navOutlineView;

//right menu item
@property (weak) IBOutlet NSMenuItem *finderMenuItem;
@property (weak) IBOutlet NSMenuItem *barMenuItem;
@property (weak) IBOutlet NSMenuItem *fileAddItem;
@property (weak) IBOutlet NSMenuItem *fileCopyItem;
@property (weak) IBOutlet NSMenuItem *fileRemoveItem;

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

-(void)selectionIndexPathsDidChange{
    JDTraceLog( @"selection");
}




-(void)selectionDidChange:(NSDictionary*)dict{
    [self willChangeValueForKey:@"selection"];
    _selection = [_documentController.selectedObjects firstObject];
    [self didChangeValueForKey:@"selection"];
}

-(void)setProject:(IUProject *)project{
    _project = project;
//    _project.delegate = self;
    [_documentController setContent:_project];
    [_documentController addObserver:self forKeyPath:@"selection" options:0 context:nil];
    
}

-(void)selectFirstDocument{
    //find first document
    [_documentController setSelectedObject:_project.pageDocuments.firstObject];
}

- (BOOL)isFolder:(NSTreeNode *)item{
    id representObject = [item representedObject];
    if ([representObject isKindOfClass:[IUProject class]] ||
        [representObject isKindOfClass:[IUDocumentGroup class]] ||
        [representObject isKindOfClass:[IUResourceGroup class]]) {
        return YES;
    }
    return NO;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode*)item {
    //folder
    if([self isFolder:item]){
        
        NSTableCellView *folder = [outlineView makeViewWithIdentifier:@"folder" owner:self];
        return folder;

    }
    //file
    else{
        NSString *cellIdentifier;
        if ([[item representedObject] isKindOfClass:[IUDocument class]]){
            IUDocument *node = [item representedObject];
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
#if 0
    NSMenu *menu = [self defaultMenu];
    
    NSTreeNode *item = [_navOutlineView itemAtRow:row];
    IUNode *node = [item representedObject];

    if([self isFolder:item]==NO){
        //TODO: make copy, remove item
        /*
        [menu addItem:_fileCopyItem];
        [menu addItem:_fileRemoveItem];
         */
    }
    if ([node isKindOfClass:[IUDocumentGroup class]]
        || [node isKindOfClass:[IUDocumentGroupNode class]]){
        
        [menu addItem:_fileAddItem];
        [menu addItem:_fileRemoveItem];
    }

    return menu;
#endif
    return nil;
}

- (NSMenu *)defaultMenu{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItem:_finderMenuItem];
    [menu addItem:_barMenuItem];

    return menu;
}
- (IBAction)clickShowInFinder:(id)sender {
    NSURL *url = [NSURL fileURLWithPath:_project.path];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[url]];
    
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
        
        [_identifierManager setNewIdentifierAndRegister:obj withKey:nil];
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
- (IBAction)clickMenuRemoveFile:(id)sender {
    assert(0);
    /*
    NSTreeNode *node = [_navOutlineView itemAtRow:_navOutlineView.rightClickedIndex];
    IUDocumentGroup *docNode = [node representedObject];
    [docNode.parent removeNode:docNode];
    [_documentController rearrangeObjects];
     */
}

- (IBAction)clickMenuCopyFile:(id)sender {
    //TODO:
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
