//
//  LMStackVC.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStackVC.h"
#import "IUController.h"
#import "IUItem.h"
#import "IUPageContent.h"
#import "IUResponsiveSection.h"
#import "IUSheet.h"
#import "LMWC.h"
#import "IUPage.h"
#import "IUClass.h"

@implementation LMStackOutlineView

- (void)keyDown:(NSEvent *)theEvent{
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if(key == NSDeleteCharacter && self.delegate)
    {
        [(LMStackVC *)self.delegate keyDown:theEvent];

    }
    else {
        [super keyDown:theEvent];
    }
}

@end


@interface LMStackVC ()

@property (weak) IBOutlet LMStackOutlineView *outlineV;
//@property (strong) IBOutlet IUController *controller;

@end

@implementation LMStackVC{
    NSArray *_draggingIndexPaths;
    id _lastClickedItem;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureChanged:) name:IUNotificationStructureDidChange object:nil];
    }
    return self;
}

-(void)awakeFromNib{
    _outlineV.delegate = self;
    [_outlineV registerForDraggedTypes:@[@"stackVC", (id)kUTTypeIUType]];
    

}

- (void)structureChanged:(NSNotification *)notification{
    [_outlineV reloadData];
}

-(void)keyDown:(NSEvent *)theEvent{
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if (key == NSDeleteCharacter) {
        for(IUBox *box in [self.IUController selectedObjects]){
            if([box shouldRemoveIUByUserInput]){
                [box.parent removeIU:box];
            }
        }
        [self.IUController rearrangeObjects];
    }
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode*)item {

    id representObject = [item representedObject];
    NSImage *classImage = [self currentImage:[representObject className]];
    
    NSTableCellView *cell;
    if([representObject isKindOfClass:[IUPageContent class]]){
        cell= [outlineView makeViewWithIdentifier:@"pagecontentCell" owner:self];
    }
    //세로로 긴 아이콘이 들어가야 하는 경우.
    else if( item.indexPath.length < 3
            || [representObject isKindOfClass:[IUClass class]]){
        cell= [outlineView makeViewWithIdentifier:@"cell" owner:self];
    }
    else{
        cell= [outlineView makeViewWithIdentifier:@"node" owner:self];
    }
    [cell.textField setStringValue:((IUBox *)representObject).name];
    [cell.imageView setImage:classImage];
    [cell.imageView setImageScaling:NSImageScaleProportionallyDown];

    return cell;
}

- (NSImage *)currentImage:(NSString *)className{
    NSString *widgetFilePath = [[NSBundle mainBundle] pathForResource:@"widgetForDefault" ofType:@"plist"];
    NSArray *availableWidgetProperties = [NSArray arrayWithContentsOfFile:widgetFilePath];
    for (NSDictionary *dict in availableWidgetProperties) {
        NSString *name = dict[@"className"];
        if([name isEqualToString:className]){
            NSImage *classImage = [NSImage imageNamed:dict[@"navImage"]];
            return classImage;
        }
    }

    return nil;
}
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
#pragma mark drag and drop

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard{
    for (NSTreeNode *node in items) {
        IUBox *iu = node.representedObject;
        if ([iu isKindOfClass:[IUItem class]] || [iu isKindOfClass:[IUSheet class]] || [iu isKindOfClass:[IUPageContent class]]) {
            return NO;
        }
    }
    
    
	[pboard declareTypes:[NSArray arrayWithObjects:@"stackVC", nil] owner:self];
    _draggingIndexPaths = [_IUController selectionIndexPaths];
	return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)ov validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)childIndex {
    
    NSPasteboard *pBoard = info.draggingPasteboard;
    if([[pBoard types] containsObject:@"stackVC"]){
        IUBox *newParent = [item representedObject];    
        if ([newParent shouldAddIUByUserInput] == NO) {
            return NSDragOperationNone;
        }
        

        NSArray *selections = [_IUController selectedObjects];
        //자기자신으로 갈 수 없음.
        if([selections containsObject:newParent]){
            return NSDragOperationNone;
        }
        //parent 가 자신의 child로 가면 안됨.
        for(IUBox *box in selections){
            if([box.allChildren containsObject:newParent]){
                return NSDragOperationNone;
            }
        }

        return NSDragOperationMove;
    }
    //newIU
    NSData *iuData = [pBoard dataForType:(id)kUTTypeIUType];
    if(iuData){
        return NSDragOperationEvery;
    }
    
    return NSDragOperationNone;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index{
    NSPasteboard *pBoard = info.draggingPasteboard;
    if([[pBoard types] containsObject:@"stackVC"]){
        NSArray *selections = [_IUController selectedObjects];
        IUBox *oldParent = [(IUBox*)[selections firstObject] parent];
        IUBox *newParent = [item representedObject];
        if (oldParent == newParent) {
            for (IUBox *iu in selections) {
                if (index == -1) {
                    index = 0;
                }
                [newParent changeIUIndex:iu to:index error:nil];
            }
        }
        else {
            for (IUBox *iu in selections) {
                NSInteger newIndex= index;
                if(newIndex < 0){
                    newIndex = 0 ;
                }
                [iu.parent removeIU:iu];
                [self.sheet.project.identifierManager registerIUs:@[iu]];                
                //we remove position tag. if not, iu will be invisible to new position
                [iu.css eradicateTag:IUCSSTagX];
                [iu.css eradicateTag:IUCSSTagY];
                
                [newParent insertIU:iu atIndex:newIndex error:nil];

            }
        }
        [_IUController rearrangeObjects];
        return YES;
    }
    
    //type1) newIU
    NSData *iuData = [pBoard dataForType:(id)kUTTypeIUType];
    if(iuData){
        LMWC *lmWC = [NSApp mainWindow].windowController;
        IUBox *newIU = lmWC.pastedNewIU;
        if(newIU){
            IUBox *newParent = [item representedObject];
            NSInteger newIndex= index;
            if(newIndex < 0){
                newIndex = 0 ;
            }
            if([newParent isKindOfClass:[IUPage class]]){
                newParent = (IUBox *)((IUPage *)newParent).pageContent;
            }
            
            int i=0;
            while([newParent shouldAddIUByUserInput] == NO){
                newParent = newParent.parent;
                
                //safe code;
                if(i>10000){
                    [JDUIUtil hudAlert:@"Can't find parent node, you try it, again" second:2];
                    return NO;
                }
            }
            
            [newParent insertIU:newIU atIndex:newIndex error:nil];
            [_IUController rearrangeObjects];
            [_IUController setSelectedObjectsByIdentifiers:@[newIU.htmlID]];

            return YES;
        }
    }
    return NO;
    
}

- (IBAction)addSectionBtn:(id)sender {
    IUBox *parent;
    
    for(IUBox *obj in _sheet.children){
        if([obj isKindOfClass:[IUPageContent class]]){
            parent = obj;
        }
    }
    if(parent == nil){
        return;
    }

    [_sheet.project.identifierManager resetUnconfirmedIUs];
    IUResponsiveSection *newIU = [[IUResponsiveSection alloc]  initWithProject:_sheet.project options:nil];
    [_sheet.project.identifierManager confirm];
    if (newIU == nil) {
        assert(0);
    }
    
    newIU.name = newIU.htmlID;
    
    [parent addIU:newIU error:nil];
    [_IUController rearrangeObjects];
    [_IUController setSelectedObjectsByIdentifiers:@[newIU.htmlID]];

}

@end