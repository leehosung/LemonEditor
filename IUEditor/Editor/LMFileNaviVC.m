//
//  LMFileNaviVC.m
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMFileNaviVC.h"
#import "IUDocumentNode.h"
#import "IUResourceNode.h"
#import "NSTreeController+JDExtension.h"
#import "IUPage.h"
#import "IUBackground.h"
#import "IUClass.h"
#import "LMWC.h"

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
    IUDocumentNode *documentNode;
    NSArray *arr = [_project allChildren];
    for (int i=0; i<[arr count]; i++) {
        if ([[arr objectAtIndex:i] isKindOfClass:[IUDocumentNode class]]) {
            documentNode = [arr objectAtIndex:i];
            break;
        }
    }
    [_documentController setSelectedObject:documentNode];
}

- (BOOL)isFolder:(NSTreeNode *)item{
    id representObject = [item representedObject];

    if(item.indexPath.length == 1 ||
       [representObject isKindOfClass:[IUDocumentGroupNode class]] ||
       [representObject isKindOfClass:[IUResourceGroupNode class]] ){
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

        if ([[item representedObject] isKindOfClass:[IUDocumentNode class]]){
            IUDocumentNode *node = [item representedObject];
            if([node.parent.name isEqualToString:@"Pages"]){
                cellIdentifier = @"pageFile";
            }
            else if([node.parent.name isEqualToString:@"Backgrounds"]){
                cellIdentifier = @"backgroundFile";
            }
            else if ([node.parent.name isEqualToString:@"Classes"]){
                cellIdentifier = @"classFile";
            }
        }
        else if( [[item representedObject] isKindOfClass:[IUResourceNode class]] ){
            IUResourceGroupNode *node = [item representedObject];
            
            if([node.parent.name isEqualToString:@"Image"]){
                cellIdentifier = @"imageFile";
            }
            else if([node.parent.name isEqualToString:@"Video"]){
                cellIdentifier = @"videoFile";
            }
            else if([node.parent.name isEqualToString:@"CSS"]){
                cellIdentifier = @"cssFile";
            }
            else if([node.parent.name isEqualToString:@"JS"]){
                cellIdentifier = @"JSFile";
            }
        }
        assert(cellIdentifier != nil);
        
        NSTableCellView *file = [outlineView makeViewWithIdentifier:cellIdentifier owner:self];
        return file;
    }
    
    
    return nil;
}

#pragma mark -
#pragma mark rightmenu
- (NSMenu *)defaultMenuForRow:(NSInteger)row{
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
    if ([node isKindOfClass:[IUDocumentNode class]]
        || [node isKindOfClass:[IUDocumentGroupNode class]]){
        
        [menu addItem:_fileAddItem];
    }

    
    return menu;
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
        
        [_identifierManager setNewIdentifierAndRegister:obj];
        obj.name = obj.htmlID;
        
        if ([obj isKindOfClass:[IUPage class]]) {
            IUDocumentNode *bg = [[_documentController.project backgroundDocumentNodes] firstObject];
            [(IUPage*)obj setBackground:bg.document];
        }
        
        IUDocumentNode *fileNode = [[IUDocumentNode alloc] init];
        fileNode.document = obj;
        fileNode.name = obj.name;
        
        [groupNode addNode:fileNode];
        LMWC *lmWC = [NSApp mainWindow].windowController;
        [lmWC setNewFileNode:fileNode];


    }
}
- (IBAction)clickMenuRemoveFile:(id)sender {
    //TODO:
}

- (IBAction)clickMenuCopyFile:(id)sender {
    //TODO:
}


@end
