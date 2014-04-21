//
//  LMIUInspectorVC.m
//  IUEditor
//
//  Created by jd on 4/11/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMIUInspectorVC.h"

#import "JDOutlineCellView.h"

#import "LMPropertyIUBoxVC.h"
#import "LMPropertyIUHTMLVC.h"
#import "LMPropertyIUFBLikeVC.h"
#import "LMPropertyIUcarouselVC.h"
#import "LMPropertyIUImageVC.h"
#import "LMPropertyIUMovieVC.h"
#import "LMPropertyIUMailLinkVC.h"
#import "LMPropertyIUTransitionVC.h"
#import "LMPropertyIUWebMovieVC.h"
#import "LMPropertyIURenderVC.h"

@interface LMIUInspectorVC (){
    LMPropertyIUImageVC *propertyIUImageVC;
    LMPropertyIUHTMLVC  *propertyIUHTMLVC;
    
    LMPropertyIUMovieVC *propertyIUMovieVC;
    LMPropertyIUFBLikeVC *propertyIUFBLikeVC;
    LMPropertyIUcarouselVC *propertyIUCarouselVC;
    
    LMPropertyIUTransitionVC *propertyIUTransitionVC;
    LMPropertyIUWebMovieVC  *propertyIUWebMovieVC;
    LMPropertyIURenderVC    *propertyIURenderVC;
    
    LMPropertyIUMailLinkVC  *propertyIUMailLinkVC;
    
    NSArray *propertyVCArray;
    NSMutableArray *selectedIUCellVArray;
}

@property (weak) IBOutlet NSOutlineView *outlineV;

@end

@implementation LMIUInspectorVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.propertyIUBoxVC = [[LMPropertyIUBoxVC alloc] initWithNibName:[LMPropertyIUBoxVC class].className bundle:nil];
        propertyIUImageVC = [[LMPropertyIUImageVC alloc] initWithNibName:[LMPropertyIUImageVC class].className bundle:nil];
        propertyIUHTMLVC = [[LMPropertyIUHTMLVC alloc] initWithNibName:[LMPropertyIUHTMLVC class].className bundle:nil];
        
        propertyIUMovieVC = [[LMPropertyIUMovieVC alloc] initWithNibName:[LMPropertyIUMovieVC class].className bundle:nil];
        propertyIUFBLikeVC = [[LMPropertyIUFBLikeVC alloc] initWithNibName:[LMPropertyIUFBLikeVC class].className bundle:nil];
        propertyIUCarouselVC = [[LMPropertyIUcarouselVC alloc] initWithNibName:[LMPropertyIUcarouselVC class].className bundle:nil];
        
        propertyIUTransitionVC = [[LMPropertyIUTransitionVC alloc] initWithNibName:[LMPropertyIUTransitionVC class].className bundle:nil];
        propertyIUWebMovieVC = [[LMPropertyIUWebMovieVC alloc] initWithNibName:[LMPropertyIUWebMovieVC class].className bundle:nil];
        propertyIURenderVC = [[LMPropertyIURenderVC alloc] initWithNibName:[LMPropertyIURenderVC class].className bundle:nil];
        
        propertyIUMailLinkVC = [[LMPropertyIUMailLinkVC alloc] initWithNibName:[LMPropertyIUMailLinkVC class].className bundle:nil];
        
        
        propertyVCArray = [NSArray arrayWithObjects:
                           @"propertyIUBoxVC",
                           @"propertyIUImageVC",
                           @"propertyIUHTMLVC",
                           @"propertyIUMovieVC",
                           @"propertyIUFBLikeVC",
                           @"propertyIUCarouselVC",
                           @"propertyIUTransitionVC",
                           @"propertyIUWebMovieVC",
                           @"propertyIURenderVC",
                           @"propertyIUMailLinkVC",
                           nil];
        selectedIUCellVArray = [NSMutableArray array];
        
        
    }
    return self;
}

-(void)awakeFromNib{
    [self.propertyIUBoxVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUImageVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUHTMLVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUMovieVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUFBLikeVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUCarouselVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUTransitionVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUWebMovieVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIURenderVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUMailLinkVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
}

-(void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];

}

- (void)setResourceManager:(IUResourceManager *)resourceManager{
    _resourceManager = resourceManager;
    
    //resource manager 가 필요한 것들은 여기서 bind
    [propertyIUImageVC bind:@"resourceManager" toObject:self withKeyPath:@"resourceManager" options:nil];
}

- (void)reloadSelectedIUArray{
    [selectedIUCellVArray removeAllObjects];
    if(self.controller.selection == nil){
        return;
    }
    NSArray *classPedigree = [self.controller selectedPedigree];
    for(NSString *className in classPedigree){
        NSString *vcName = [NSString stringWithFormat:@"property%@VC", className];
        if([propertyVCArray containsObject:vcName]){
            NSViewController *iuVC = [self valueForKeyPath:vcName];
            [selectedIUCellVArray addObject:iuVC.view];
        }
    }
}


-(void)selectedObjectsDidChange:(NSDictionary *)change{
    [self reloadSelectedIUArray];
    [_outlineV reloadData];
}

#pragma mark -
#pragma mark outlineView

- (NSView *)contentViewOfTitleView:(NSView *)titleV{
    for(JDOutlineCellView *cellV in selectedIUCellVArray){
        if( [cellV.titleV isEqualTo:titleV] ){
            return cellV.contentV;
        }
    }
    return nil;
}

//return number of child
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(NSView *)item{
    
    if(item == nil){
        return selectedIUCellVArray.count;
    }
    else{
        if([[item identifier] containsString:@"title"]){
            return 1;
        }
        else{
            return 0;
        }
    }
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if(item == nil){
        JDOutlineCellView *view = selectedIUCellVArray[index];
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
