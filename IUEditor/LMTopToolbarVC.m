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
@property (weak) IBOutlet NSButton *hiddenTabBtn;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSheet:) name:IUNotificationStructureDidChange object:nil];
    
    [self.view addObserver:self forKeyPath:@"frame" options:0 context:nil];

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
                [self moveOpenTabToHiddenTab];
            }
            
            //2. add opentabdocuments
            [self addOpenTabDocuments:sheet];
        case LMTabDocumentTypeOpen:
            //select
            [self selectTab:sheet];
        default:
            break;
    }
    
    [self updateHiddenTabBtn];
}

- (void)removeSheet:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[IUNotificationStructureChangeType] isEqualToString:IUNotificationStructureChangeRemoving] ){
        IUSheet *sheet = [userInfo objectForKey:IUNotificationStructureChangedIU];
        if([sheet isKindOfClass:[IUSheet class]]){
            [self removeDocument:sheet];
        }
    }

}
#pragma mark -
#pragma mark tabview

- (void)removeDocument:(IUSheet *)sheet{
    if([openTabDocuments containsObject:sheet]){
        LMFileTabItemVC *item = [self tabItemOfDocumentNode:sheet];
        [self closeTab:item sender:sheet];
        
    }
    else if([hiddenTabDocuments containsObject:sheet]){
        [hiddenTabDocuments removeObject:sheet];
        [self updateHiddenTabBtn];
    }
}



- (void)addOpenTabDocuments:(IUSheet *)sheet{
    [openTabDocuments addObject:sheet];
    
    LMFileTabItemVC *itemVC = [[LMFileTabItemVC alloc] initWithNibName:@"LMFileTabItemVC" bundle:nil];
    [itemVC setSheet:sheet];
    itemVC.delegate = self;
    
    [_fileTabView addSubviewDirectionLeftToRight:itemVC.view width:140];
    
    [itemVC setDeselectColor];
}



- (LMFileTabItemVC *)tabItemOfDocumentNode:(IUSheet *)sheet{
    for(LMTabBox *item in _fileTabView.subviews){
        NSAssert([item isKindOfClass:[LMTabBox class]], @"");
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

- (BOOL)isFloodOpenTab{
    CGFloat size = _fileTabView.frame.size.width - 140 * openTabDocuments.count;
    if(size  < 0){
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

- (void)updateHiddenTabBtn{
    if(hiddenTabDocuments.count == 0){
        [_hiddenTabBtn setTransparent:YES];
    }
    else{
        [_hiddenTabBtn setTransparent:NO];
    }
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

#pragma mark - change to open and hidden

- (void)moveOpenTabToHiddenTab{
    IUSheet *lastOpenedDocument = [openTabDocuments lastObject];
    if([lastOpenedDocument isEqualTo:_sheet]){
        lastOpenedDocument = [openTabDocuments objectBeforeObject:lastOpenedDocument];
    }
    LMFileTabItemVC *item = [self tabItemOfDocumentNode:lastOpenedDocument];
    [self closeTab:item sender:self];
    
    [hiddenTabDocuments addObject:lastOpenedDocument];
    [self updateHiddenTabBtn];
}


- (void)moveHiddenTabToOpenTab{
    IUSheet *sheet = [hiddenTabDocuments lastObject];
    if(sheet){
        [hiddenTabDocuments removeLastObject];
        [self addOpenTabDocuments:sheet];
        [self updateHiddenTabBtn];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.view && [keyPath isEqualToString:@"frame"]) {
        
        //방어코드
        int i=0;
        //window가 커졌을 때 hiddenTab을 openTab으로 옮김
        while([self hasEnoughSize] && hiddenTabDocuments.count > 0){
            [self moveHiddenTabToOpenTab];
            i++;
            if(i>10000){
                break;
            }
        }
        
        i=0;
        //window가 작아졌을때 openTab을 hiddenTab으로
        while([self isFloodOpenTab]){
            [self moveOpenTabToHiddenTab];
            i++;
            if(i>10000){
                break;
            }
        }
    }
}



#pragma mark -
#pragma mark tab item  delegate



- (void)selectTab:(IUSheet *)sheet{
    [_sheetController setSelectedObject:sheet];
    
    //tabcolor
    for(LMTabBox *item in _fileTabView.subviews){
        NSAssert([item isKindOfClass:[LMTabBox class]], @"");
        LMFileTabItemVC *itemVC = ((LMFileTabItemVC *)item.delegate);
        
        if([itemVC.sheet isEqualTo:sheet]){
            [itemVC setSelectColor];
        }
        else{
            [itemVC setDeselectColor];
        }
    }
    
}

- (void)closeTab:(LMFileTabItemVC *)tabItem sender:(id)sender{
    if(openTabDocuments.count == 1){
        return ;
    }
    if (openTabDocuments.count == 0) {
        NSAssert(0, @"");
    }
    
    NSInteger index = [openTabDocuments indexOfObject:tabItem.sheet];
    IUSheet *selectNode;
    if (index == NSNotFound) {
        NSAssert(0, @"");
    }
    NSAssert(index < openTabDocuments.count, @"");

    if(index > 0){
        [tabItem.view removeFromSuperviewWithDirectionLeftToRight];
         selectNode = [openTabDocuments objectAtIndex:index-1];
    }
    else{
        [tabItem.view removeFromSuperviewWithFirstLeftTab];
         selectNode = [openTabDocuments objectAtIndex:index+1];

        
    }
    [openTabDocuments removeObject:tabItem.sheet];
    
    
    //call by tabview
    if([sender isNotEqualTo:self]){
        [self moveHiddenTabToOpenTab];
        if(selectNode){
            [_sheetController setSelectedObject:selectNode];
        }

    }
    
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
