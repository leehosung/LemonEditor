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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSheet:) name:IUNotificationStructureChanged object:nil];    

}

//set from lmwc
-(void)setSheet:(IUSheet *)sheet{
    _sheet = sheet;
    //find tab or make new box
    LMTabDocumentType currentState = [self stateOfDocumnet:sheet];
    switch (currentState) {
        case LMTabDocumentTypeHidden:
            //remove hidden state
            [hiddenTabDocuments removeObject:sheet];
            
        case LMTabDocumentTypeNone:
            //1. check enough size -> ignore or move one to hidden tab
            if([self hasEnoughSize] == NO){
                IUSheet *lastOpenedDocument = [openTabDocuments objectAtIndex:[openTabDocuments count] -1];
                [self removeOpenTabDocument:lastOpenedDocument];
            }
            
            //2. add opentabdocuments
            [self addOpenTabDocuments:sheet];
        case LMTabDocumentTypeOpen:
            //select
            [self selectTab:sheet];
        default:
            break;
    }
}

- (void)removeSheet:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[IUNotificationStructureType] isEqualToString:IUNotificationStructureTypeRemove] ){
        IUSheet *sheet = [userInfo objectForKey:IUNotificationStructureTarget];
        if([sheet isKindOfClass:[IUSheet class]]){
            [self removeDocument:sheet];
        }
    }

}
#pragma mark -
#pragma mark tabview
- (void)removeDocument:(IUSheet *)sheet{
    if([openTabDocuments containsObject:sheet]){
        [openTabDocuments removeObject:sheet];
        LMFileTabItemVC *item = [self tabItemOfDocumentNode:sheet];
        [item.view removeFromSuperviewWithDirectionLeftToRight];
    }
    else if([hiddenTabDocuments containsObject:sheet]){
        [hiddenTabDocuments removeObject:sheet];
    }
}

- (void)removeOpenTabDocument:(IUSheet *)sheet{
    [openTabDocuments removeObject:sheet];
    
    LMFileTabItemVC *item = [self tabItemOfDocumentNode:sheet];
    [item.view removeFromSuperviewWithDirectionLeftToRight];

    [hiddenTabDocuments addObject:sheet];
}


- (void)addOpenTabDocuments:(IUSheet *)sheet{
    [openTabDocuments addObject:sheet];
    
    LMFileTabItemVC *itemVC = [[LMFileTabItemVC alloc] initWithNibName:@"LMFileTabItemVC" bundle:nil];
    [itemVC setSheet:sheet];
    itemVC.delegate = self;
    
    [_fileTabView addSubviewDirectionLeftToRight:itemVC.view width:140];
}



- (LMFileTabItemVC *)tabItemOfDocumentNode:(IUSheet *)sheet{
    for(LMTabBox *item in _fileTabView.subviews){
        assert([item isKindOfClass:[LMTabBox class]]);
        LMFileTabItemVC *itemVC = ((LMFileTabItemVC *)item.delegate);
        if([itemVC.sheet isEqualTo:sheet]){
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


- (LMTabDocumentType)stateOfDocumnet:(IUSheet *)sheet{
    if([openTabDocuments containsObject:sheet]){
        return LMTabDocumentTypeOpen;
    }
    else if([hiddenTabDocuments containsObject:sheet]){
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
    IUSheet *sheet = [sender representedObject];
    [self setSheet:sheet];
}

- (IBAction)clickHiddenTabs:(id)sender {
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    
    int index=0;
    for(IUSheet *sheet in hiddenTabDocuments){
        NSMenuItem *item = [theMenu insertItemWithTitle:sheet.name action:@selector(selectHiddenDocument:) keyEquivalent:@"" atIndex:index];
        [item setTarget:self];
        [item setRepresentedObject:sheet];
        index++;
    }
    
    [NSMenu popUpContextMenu:theMenu withEvent:[NSApp currentEvent] forView:self.view];
}



#pragma mark -
#pragma mark tab item  delegate



- (void)selectTab:(IUSheet *)sheet{
    [_sheetController setSelectedObject:sheet];
    
    //tabcolor
    for(LMTabBox *item in _fileTabView.subviews){
        assert([item isKindOfClass:[LMTabBox class]]);
        LMFileTabItemVC *itemVC = ((LMFileTabItemVC *)item.delegate);
        
        if([itemVC.sheet isEqualTo:sheet]){
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
    if (openTabDocuments.count == 0) {
        assert(0);
    }
    
    NSInteger index = [openTabDocuments indexOfObject:tabItem.sheet];
    if (index == NSNotFound) {
        assert(0);
    }
    assert(index < openTabDocuments.count);

    if(index > 0){
        [tabItem.view removeFromSuperviewWithDirectionLeftToRight];
        IUSheet *leftTabNode = [openTabDocuments objectAtIndex:index-1];
        [_sheetController setSelectedObject:leftTabNode];
    }
    else{
        [tabItem.view removeFromSuperviewWithFirstLeftTab];
        IUSheet *rightTabNode = [openTabDocuments objectAtIndex:index+1];
        [_sheetController setSelectedObject:rightTabNode];

        
    }
    [openTabDocuments removeObject:tabItem.sheet];
        
    
    
}


#pragma mark -
#pragma mark build

- (IBAction)showBPressed:(id)sender {
    IUProject *project = _sheetController.project;
    [project build:nil];

    IUSheet *node = [[_sheetController selectedObjects] firstObject];
    NSString *firstPath = [project.directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.html",project.buildPath, [node.name lowercaseString]] ];
    
    [[NSWorkspace sharedWorkspace] openFile:firstPath];
}



@end
