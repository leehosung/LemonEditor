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

@interface LMAppearanceVC ()

@end

@implementation LMAppearanceVC{
    LMPropertyFrameVC    *propertyFrameVC;
    LMPropertyBorderVC  *propertyBorderVC;
    LMPropertyBGColorVC *propertyBGColorVC;
    LMPropertyTextVC    *propertyTextVC;
    LMPropertyShadowVC  *propertyShadowVC;
    
    NSMutableArray *outlineVOrderArray;
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
        
        propertyBorderVC = [[LMPropertyBorderVC alloc] initWithNibName:@"LMPropertyBorderVC" bundle:nil];
        [propertyBorderVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        
        propertyBGColorVC = [[LMPropertyBGColorVC alloc] initWithNibName:@"LMPropertyBGColorVC" bundle:nil];
        [propertyBGColorVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
        
        propertyTextVC = [[LMPropertyTextVC alloc] initWithNibName:@"LMPropertyTextVC" bundle:nil];
        propertyShadowVC = [[LMPropertyShadowVC alloc] initWithNibName:@"LMPropertyShadowVC" bundle:nil];
        
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
        return outlineVOrderArray.count;
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
        JDOutlineCellView *view = outlineVOrderArray[index];
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
    assert(item != nil);
    CGFloat height = item.frame.size.height;
    if(height <=0){
        height = 0.1;
    }
    return height;
    
}


@end
