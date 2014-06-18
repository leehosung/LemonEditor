//
//  LMAppearanceVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMAppearanceVC.h"
#import "LMPropertyFrameVC.h"
#import "LMPropertyBorderVC.h"
#import "LMPropertyBGColorVC.h"
#import "LMPropertyTextVC.h"
#import "LMPropertyShadowVC.h"
#import "LMPropertyOverflowVC.h"

@interface LMAppearanceVC ()

@end

@implementation LMAppearanceVC{
    LMPropertyFrameVC    *propertyFrameVC;
    LMPropertyBorderVC  *propertyBorderVC;
    LMPropertyBGColorVC *propertyBGColorVC;
    LMPropertyTextVC    *propertyTextVC;
    LMPropertyShadowVC  *propertyShadowVC;
    LMPropertyOverflowVC *propertyOverflowVC;
    
    NSMutableArray *outlineVOrderArray;
}

- (NSString*)CSSBindingPath:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //init VC
        propertyFrameVC = [[LMPropertyFrameVC alloc] initWithNibName:@"LMPropertyFrameVC" bundle:nil];
        [propertyFrameVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        
        self.propertyBGImageVC = [[LMPropertyBGImageVC alloc] initWithNibName:@"LMPropertyBGImageVC" bundle:nil];
        [self.propertyBGImageVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        [self.propertyBGImageVC bind:@"resourceManager" toObject:self withKeyPath:@"resourceManager" options:nil];
        
        propertyBorderVC = [[LMPropertyBorderVC alloc] initWithNibName:@"LMPropertyBorderVC" bundle:nil];
        [propertyBorderVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        
        propertyBGColorVC = [[LMPropertyBGColorVC alloc] initWithNibName:@"LMPropertyBGColorVC" bundle:nil];
        [propertyBGColorVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        
        propertyTextVC = [[LMPropertyTextVC alloc] initWithNibName:@"LMPropertyTextVC" bundle:nil];
        [propertyTextVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];

        propertyShadowVC = [[LMPropertyShadowVC alloc] initWithNibName:@"LMPropertyShadowVC" bundle:nil];
        [propertyShadowVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        
        propertyOverflowVC = [[LMPropertyOverflowVC alloc] initWithNibName:@"LMPropertyOverflowVC" bundle:nil];
        [propertyOverflowVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    }
    return self;
}

- (void)awakeFromNib{
    //make array
    outlineVOrderArray = [NSMutableArray array];
    [outlineVOrderArray addObject:propertyFrameVC.view];
    [outlineVOrderArray addObject:propertyBGColorVC.view];
    [outlineVOrderArray addObject:self.propertyBGImageVC.view];
    [outlineVOrderArray addObject:propertyTextVC.view];
    [outlineVOrderArray addObject:propertyShadowVC.view];
    [outlineVOrderArray addObject:propertyBorderVC.view];
    [outlineVOrderArray addObject:propertyOverflowVC.view];
}

- (NSView *)contentViewOfTitleView:(NSView *)titleV{
    for(JDOutlineCellView *cellV in outlineVOrderArray){
        if( [cellV.titleV isEqualTo:titleV] ){
            return cellV.contentV;
        }
    }
    return nil;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if(item == nil){
        //root
        return outlineVOrderArray.count;
    }
    else{
        if([((JDOutlineCellView *)propertyFrameVC.view).titleV isEqualTo:item]){
            return 0;
        }
        else if([((JDOutlineCellView *)propertyOverflowVC.view).titleV isEqualTo:item]){
            return 0;
        }
        else if([[item identifier] isEqualToString:@"title"]){
            return 1;
        }
        return 0;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if(item == nil){
        JDOutlineCellView *view = outlineVOrderArray[index];
        return view.titleV;
    }
    else{
        return [self contentViewOfTitleView:item];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    if([((JDOutlineCellView *)propertyFrameVC.view).titleV isEqualTo:item]){
            return NO;
    }
    else if([((JDOutlineCellView *)propertyOverflowVC.view).titleV isEqualTo:item]){
        return 0;
    }

    //root or title V
    else if(item == nil || [[item identifier] isEqualToString:@"title"]){
        return YES;
    }

    return NO;
}


- (id)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    return item;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(NSView *)item{
    assert(item != nil);
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
