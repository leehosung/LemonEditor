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
#import "LMPropertyIUImportVC.h"
#import "LMPropertyIUTextFieldVC.h"
#import "LMPropertyIUCollectionVC.h"
#import "LMPropertyIUTextViewVC.h"
#import "LMPropertyIUPageLinkSetVC.h"
#import "LMPropertyIUPageVC.h"
#import "LMPropertyIUFormVC.h"
#import "LMPropertyIUTextVC.h"


@interface LMIUInspectorVC (){
    
    LMPropertyIUBoxVC   *propertyIUBoxVC;
    LMPropertyIUImageVC *propertyIUImageVC;
    LMPropertyIUHTMLVC  *propertyIUHTMLVC;
    
    LMPropertyIUMovieVC *propertyIUMovieVC;
    LMPropertyIUFBLikeVC *propertyIUFBLikeVC;
    LMPropertyIUcarouselVC *propertyIUCarouselVC;
    
    LMPropertyIUTransitionVC *propertyIUTransitionVC;
    LMPropertyIUWebMovieVC  *propertyIUWebMovieVC;
    LMPropertyIUImportVC    *propertyIUImportVC;
    
    LMPropertyIUMailLinkVC  *propertyIUMailLinkVC;
    LMPropertyIUTextFieldVC *propertyIUTextFieldVC;
    LMPropertyIUCollectionVC  *propertyIUCollectionVC;
    
    LMPropertyIUTextViewVC *propertyIUTextViewVC;
    LMPropertyIUPageLinkSetVC *propertyIUPageLinkSetVC;
    LMPropertyIUPageVC * propertyIUPageVC;
    
    LMPropertyIUFormVC *propertyIUFormVC;
    LMPropertyIUTextVC *textVC;
    
    NSArray *propertyVCArray;
    NSInteger countOfAdvanced;
}

@property (strong) IBOutlet NSBox *defaultTitleV;
@property (strong) IBOutlet NSBox *advancedTitleV;
@property (strong) IBOutlet NSView *advancedContentV;

@property (weak) IBOutlet NSOutlineView *outlineV;
@property (weak) IBOutlet NSTextField *advancedTF;

@end

@implementation LMIUInspectorVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        propertyIUBoxVC = [[LMPropertyIUBoxVC alloc] initWithNibName:[LMPropertyIUBoxVC class].className bundle:nil];
        propertyIUImageVC = [[LMPropertyIUImageVC alloc] initWithNibName:[LMPropertyIUImageVC class].className bundle:nil];
        propertyIUHTMLVC = [[LMPropertyIUHTMLVC alloc] initWithNibName:[LMPropertyIUHTMLVC class].className bundle:nil];
        
        propertyIUMovieVC = [[LMPropertyIUMovieVC alloc] initWithNibName:[LMPropertyIUMovieVC class].className bundle:nil];
        propertyIUFBLikeVC = [[LMPropertyIUFBLikeVC alloc] initWithNibName:[LMPropertyIUFBLikeVC class].className bundle:nil];
        propertyIUCarouselVC = [[LMPropertyIUcarouselVC alloc] initWithNibName:[LMPropertyIUcarouselVC class].className bundle:nil];
        
        propertyIUTransitionVC = [[LMPropertyIUTransitionVC alloc] initWithNibName:[LMPropertyIUTransitionVC class].className bundle:nil];
        propertyIUWebMovieVC = [[LMPropertyIUWebMovieVC alloc] initWithNibName:[LMPropertyIUWebMovieVC class].className bundle:nil];
        propertyIUImportVC = [[LMPropertyIUImportVC alloc] initWithNibName:[LMPropertyIUImportVC class].className bundle:nil];
        
        propertyIUMailLinkVC = [[LMPropertyIUMailLinkVC alloc] initWithNibName:[LMPropertyIUMailLinkVC class].className bundle:nil];

        propertyIUTextFieldVC = [[LMPropertyIUTextFieldVC alloc] initWithNibName:[LMPropertyIUTextFieldVC class].className bundle:nil];
        propertyIUCollectionVC = [[LMPropertyIUCollectionVC alloc] initWithNibName:[LMPropertyIUCollectionVC class].className bundle:nil];
        propertyIUTextViewVC = [[LMPropertyIUTextViewVC alloc] initWithNibName:[LMPropertyIUTextViewVC class].className bundle:nil];
        
        propertyIUPageLinkSetVC = [[LMPropertyIUPageLinkSetVC alloc] initWithNibName:[LMPropertyIUPageLinkSetVC class].className bundle:nil];
        propertyIUPageVC = [[LMPropertyIUPageVC alloc] initWithNibName:[LMPropertyIUPageVC class].className bundle:nil];
        propertyIUFormVC = [[LMPropertyIUFormVC alloc] initWithNibName:[LMPropertyIUFormVC class].className bundle:nil];
        
        textVC = [[LMPropertyIUTextVC alloc] initWithNibName:[LMPropertyIUTextVC class].className bundle:nil];
        
        propertyVCArray = [NSArray arrayWithObjects:
                           @"propertyIUImageVC",
                           @"propertyIUHTMLVC",
                           @"propertyIUMovieVC",
                           @"propertyIUFBLikeVC",
                           @"propertyIUCarouselVC",
                           @"propertyIUTransitionVC",
                           @"propertyIUWebMovieVC",
                           @"propertyIUImportVC",
                           @"propertyIUMailLinkVC",
                           @"propertyIUTextFieldVC",
                           @"propertyIUCollectionVC",
                           @"propertyIUTextViewVC",
                           @"propertyIUPageLinkSetVC",
                           @"propertyIUPageVC",
                           @"propertyIUFormVC",
                           @"propertyIUBoxVC",
                           nil];
        
    }
    return self;
}

-(void)awakeFromNib{
    [propertyIUBoxVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUImageVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUHTMLVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUMovieVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUFBLikeVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUCarouselVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUTransitionVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUWebMovieVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];

    [propertyIUImportVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUImportVC bind:@"classDocuments" toObject:self withKeyPath:@"classDocuments" options:nil];
    
    [propertyIUMailLinkVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUTextFieldVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUCollectionVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUTextViewVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUPageLinkSetVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUPageVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUFormVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [textVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];

    

}

- (void)setPageDocumentNodes:(NSArray *)pageDocumentNodes{
    _pageDocumentNodes = pageDocumentNodes;
    propertyIUBoxVC.pageDocumentNodes = pageDocumentNodes;
    
}

-(void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
}

- (void)setResourceManager:(IUResourceManager *)resourceManager{
    _resourceManager = resourceManager;
    propertyIUImageVC.resourceManager = resourceManager;
    propertyIUCarouselVC.resourceManager = resourceManager;
    propertyIUMovieVC.resourceManager = resourceManager;
}

- (void)reloadSelectedIUArray{

    NSArray *removeViewArray = [_advancedContentV.subviews copy];
    for(NSView *childView in removeViewArray){
        [childView removeFromSuperview];
    }
    
    if(self.controller.selection == nil && self.controller.selectedObjects.count == 0){
        return;
    }
    //change name
    if(self.controller.selectedObjects.count ==1){
        [_advancedTF setStringValue:[self.controller.selection className]];
    }
    else{
        [_advancedTF setStringValue:@"Advanced Property"];
    }
    
    //find current view
    NSArray *classPedigree = [self.controller selectedPedigree];
    NSMutableArray *viewArray = [NSMutableArray array];
    for(NSString *className in classPedigree){
        NSString *vcName = [NSString stringWithFormat:@"property%@VC", className];
        if([propertyVCArray containsObject:vcName]){
            NSViewController *iuVC = [self valueForKeyPath:vcName];
            NSView *view;
            if([iuVC.view isKindOfClass:[JDOutlineCellView class]]){
                view = ((JDOutlineCellView *)iuVC.view).contentV;
            }
            else{
                view = iuVC.view;
            }
            [viewArray addObject:view];
        }
    }
    
    //add textVC if has text
    if(self.controller.selectedObjects.count == 1 && [((IUBox *)self.controller.selection) hasText]){
        [viewArray insertObject:textVC.view atIndex:0];
    }
    
    //make advanced view
    CGFloat height=0;
    NSView *bottomView;

    for(int i=0; i<viewArray.count; i++){
        NSView *view = [viewArray objectAtIndex:i];
        height += view.frame.size.height;
        if(i == 0){
            [_advancedContentV addSubviewFullFrameAtBottom:view height:view.frame.size.height];
        }
        else if(i==viewArray.count -1){
            [_advancedContentV addSubviewFullFrameAtTop:view height:view.frame.size.height toBottomView:bottomView];
        }
        else{
            [_advancedContentV addSubviewFullFrame:view height:view.frame.size.height toBottomView:bottomView];
        }
        bottomView = view;
        
    }
    [_advancedContentV setHeight:height];
    countOfAdvanced = viewArray.count;
}


-(void)selectedObjectsDidChange:(NSDictionary *)change{
    [self reloadSelectedIUArray];
    [_outlineV reloadData];
}


#pragma mark -
#pragma mark outlineView

//return number of child
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(NSView *)item{
    
    if(item == nil){
        return 2;
    }
    else
    {
        if([[item identifier] isEqualToString:@"defaultTitleV"]){
            return 1;
        }
        else if([[item identifier] isEqualToString:@"advancedTitleV"] && countOfAdvanced > 0){
            return 1;
        }

        else{
            return 0;
        }
    }
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if(item == nil){
        if(index==0){
            return _defaultTitleV;
        }
        else if(index == 1){
            return _advancedTitleV;
        }
        else{
            assert(0);
            return nil;
        }
    }
    else{
        if([item isEqualTo:_defaultTitleV]){
            return  propertyIUBoxVC.defaultView;
            
        }else if([item isEqualTo:_advancedTitleV]){
            return _advancedContentV;
        }
        else{
            assert(0);
            return nil;
        }
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    //root or title V
    if([[item identifier] containsString:@"TitleV"]){
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
    id clickItem = [sender itemAtRow:[_outlineV clickedRow]];
    
    [sender isItemExpanded:clickItem] ?
    [sender.animator collapseItem:clickItem] : [sender.animator expandItem:clickItem];
}

@end
