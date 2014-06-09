//
//  LMTopToolbarVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMTopToolbarVC.h"
#import "LMFileTabItemVC.h"
#import "NSTreeController+JDExtension.h"


@interface LMTopToolbarVC (){
    NSMutableArray  *openTabDocuments;
    NSMutableArray  *hiddenTabDocuments;
}

@property (weak) IBOutlet NSView *fileTabView;

@end

@implementation LMTopToolbarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        openTabDocuments = [NSMutableArray array];
        hiddenTabDocuments = [NSMutableArray array];
    }
    return self;
}
- (void)awakeFromNib{
    
}

//set from lmwc
-(void)setDocument:(IUDocument *)document{
    _document = document;
    //find tab or make new box
    LMTabDocumentType currentState = [self stateOfDocumnet:document];
    switch (currentState) {
        case LMTabDocumentTypeHidden:
            //remove hidden state
            [hiddenTabDocuments removeObject:document];
            
        case LMTabDocumentTypeNone:
            //1. check enough size -> ignore or move one to hidden tab
            if([self hasEnoughSize] == NO){
                IUDocument *lastOpenedDocument = [openTabDocuments objectAtIndex:[openTabDocuments count] -1];
                [self removeOpenTabDocument:lastOpenedDocument];
            }
            
            //2. add opentabdocuments
            [self addOpenTabDocuments:document];
        case LMTabDocumentTypeOpen:
            //select
            [self selectTab:document];
        default:
            break;
    }
}

#pragma mark -
#pragma mark tabview

- (void)removeOpenTabDocument:(IUDocument *)document{
    [openTabDocuments removeObject:document];
    
    LMFileTabItemVC *item = [self tabItemOfDocumentNode:document];
    [item.view removeFromSuperviewWithDirectionLeftToRight];

    [hiddenTabDocuments addObject:document];
}

- (void)addOpenTabDocuments:(IUDocument *)document{
    [openTabDocuments addObject:document];
    
    LMFileTabItemVC *itemVC = [[LMFileTabItemVC alloc] initWithNibName:@"LMFileTabItemVC" bundle:nil];
    [itemVC setDocument:document];
    itemVC.delegate = self;
    
    [_fileTabView addSubviewDirectionLeftToRight:itemVC.view width:140];
}



- (LMFileTabItemVC *)tabItemOfDocumentNode:(IUDocument *)documentNode{
    for(LMTabBox *item in _fileTabView.subviews){
        assert([item isKindOfClass:[LMTabBox class]]);
        LMFileTabItemVC *itemVC = ((LMFileTabItemVC *)item.delegate);
        if([itemVC.document isEqualTo:documentNode]){
            return itemVC;
        }
    }
    return nil;
}


- (BOOL)hasEnoughSize{
    CGFloat size = _fileTabView.frame.size.width - 140 * openTabDocuments.count;
    if(size  > 50){
        return YES;
    }
    else{
        return NO;
    }
}

- (LMTabDocumentType)stateOfDocumnet:(IUDocument *)document{
    if([openTabDocuments containsObject:document]){
        return LMTabDocumentTypeOpen;
    }
    else if([hiddenTabDocuments containsObject:document]){
        return LMTabDocumentTypeHidden;
    }
    else{
        return LMTabDocumentTypeNone;
    }
}

- (BOOL)isAddToOpenTab{
    return YES;
}

- (IBAction)selectHiddenDocument:(id)sender{
    IUDocument *document = [sender representedObject];
    [self setDocument:document];
}

- (IBAction)clickHiddenTabs:(id)sender {
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    
    int index=0;
    for(IUDocument *documentNode in hiddenTabDocuments){
        NSMenuItem *item = [theMenu insertItemWithTitle:documentNode.name action:@selector(selectHiddenDocument:) keyEquivalent:@"" atIndex:index];
        [item setTarget:self];
        [item setRepresentedObject:documentNode];
        index++;
    }
    
    [NSMenu popUpContextMenu:theMenu withEvent:[NSApp currentEvent] forView:self.view];
}



#pragma mark -
#pragma mark tab item  delegate



- (void)selectTab:(IUDocument *)documentNode{
    [_documentController setSelectedObject:documentNode];
    
    //tabcolor
    for(LMTabBox *item in _fileTabView.subviews){
        assert([item isKindOfClass:[LMTabBox class]]);
        LMFileTabItemVC *itemVC = ((LMFileTabItemVC *)item.delegate);
        
        if([itemVC.document isEqualTo:documentNode]){
            [itemVC setSelectColor];
        }
        else{
            [itemVC setDeselectColor];
        }
    }
    
}

- (void)closeTab:(LMFileTabItemVC *)tabItem{
    if(openTabDocuments.count == 1){
        return ;
    }
    [tabItem.view removeFromSuperviewWithDirectionLeftToRight];
    
    
    NSInteger index = [openTabDocuments indexOfObject:tabItem.document]-1;
    
    assert(index < openTabDocuments.count);
    
    IUDocument *leftTabNode = [openTabDocuments objectAtIndex:index];
    [_documentController setSelectedObject:leftTabNode];
    
    [openTabDocuments removeObject:tabItem.document];
    
    
}


#pragma mark -
#pragma mark build

- (IBAction)showBPressed:(id)sender {
    IUProject *project = _documentController.project;
    [project build:nil];
    IUDocument *node = [[_documentController selectedObjects] firstObject];
    NSString *firstPath = [project.directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.html",project.buildPath, [node.name lowercaseString]] ];
    
    [[NSWorkspace sharedWorkspace] openFile:firstPath];
}



@end
