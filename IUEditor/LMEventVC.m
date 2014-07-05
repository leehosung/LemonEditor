//
//  LMEventVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMEventVC.h"

#import "JDOutlineCellView.h"

#import "LMEventMouseOnVC.h"
#import "LMEventVariableTrigger.h"
#import "LMEventVariableReceiverVC.h"
#import "LMEventVariableReceiverFrameVC.h"
#import "LMEventScrollAnimationVC.h"

@interface LMEventVC ()

@end

@implementation LMEventVC{
    LMEventMouseOnVC *propertyMouseEventVC;
    LMEventVariableTrigger    *propertyTriggerVC;
    LMEventVariableReceiverVC     *propertyVisibleVC;
    LMEventVariableReceiverFrameVC     *propertyFrameVC;
    LMEventScrollAnimationVC  *propertyScrollVC;
    
    NSArray *eventOutlineVOrderArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        //alloc outline cell view
        propertyMouseEventVC = [[LMEventMouseOnVC alloc] initWithNibName:@"LMEventMouseOnVC" bundle:nil];
        propertyTriggerVC = [[LMEventVariableTrigger alloc] initWithNibName:@"LMEventVariableTrigger" bundle:nil];
        propertyVisibleVC = [[LMEventVariableReceiverVC alloc] initWithNibName:@"LMEventVariableReceiverVC" bundle:nil];
        propertyFrameVC = [[LMEventVariableReceiverFrameVC alloc] initWithNibName:@"LMEventVariableReceiverFrameVC" bundle:nil];
        propertyScrollVC = [[LMEventScrollAnimationVC alloc] initWithNibName:[LMEventScrollAnimationVC class].className bundle:nil];
        
        [propertyMouseEventVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        [propertyTriggerVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        [propertyVisibleVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        [propertyFrameVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        [propertyScrollVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];

        
    }
    return self;
}

-(void)awakeFromNib{
    eventOutlineVOrderArray = [NSArray arrayWithObjects:propertyMouseEventVC.view,
                               propertyScrollVC.view,
                               propertyTriggerVC.view,
                               propertyVisibleVC.view,
                               propertyFrameVC.view,
                               nil];
}


- (NSView *)contentViewOfTitleView:(NSView *)titleV{
    for(JDOutlineCellView *cellV in eventOutlineVOrderArray){
        if( [cellV.titleV isEqualTo:titleV] ){
            return cellV.contentV;
        }
    }
    return nil;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if(item == nil){
        return eventOutlineVOrderArray.count;
    }
    else{
        if([[item identifier] isEqualToString:@"title"]){
            return 1;
        }
        return 0;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if(item == nil){
        JDOutlineCellView *view = eventOutlineVOrderArray[index];
        return view.titleV;
    }
    else{
        return [self contentViewOfTitleView:item];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    //root or title V
    if(item == nil || [[item identifier] isEqualToString:@"title"]){
        return YES;
    }
    
    return NO;
}


- (id)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    return item;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(NSView *)item{
    NSAssert(item != nil, @"");
    CGFloat height = item.frame.size.height;
    if(height <=0){
        height = 0.1;
    }
    return height;
    
}

- (IBAction)outlineViewClicked:(NSOutlineView *)sender{
    id clickItem = [sender itemAtRow:[sender clickedRow]];
    
    [sender isItemExpanded:clickItem] ?
    [sender.animator collapseItem:clickItem] : [sender.animator expandItem:clickItem];
}


@end
