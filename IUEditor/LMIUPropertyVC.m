//
//  LMIUInspectorVC.m
//  IUEditor
//
//  Created by jd on 4/11/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMIUPropertyVC.h"

#import "JDOutlineCellView.h"

#import "LMInspectorLinkVC.h"
#import "LMPropertyIUHTMLVC.h"
#import "LMPropertyIUFBLikeVC.h"
#import "LMPropertyIUcarouselVC.h"
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
#import "LMPropertyPGFormVC.h"
#import "LMPropertyIUTextVC.h"
#import "PGSubmitButtonVC.h"

#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION

#import "LMPropertyTextVC.h"

#endif

#import "LMPropertyProgrammingType1VC.h"
#import "LMPropertyProgrammingType2VC.h"

#import "IUProject.h"


@interface LMIUPropertyVC (){
    IUProject   *_project;
    
    LMInspectorLinkVC   *inspectorLinkVC;
    LMPropertyIUHTMLVC  *propertyIUHTMLVC;
    
    LMPropertyIUMovieVC *propertyIUMovieVC;
    LMPropertyIUFBLikeVC *propertyIUFBLikeVC;
    LMPropertyIUcarouselVC *propertyIUCarouselVC;
    
    LMPropertyIUTransitionVC *propertyIUTransitionVC;
    LMPropertyIUWebMovieVC  *propertyIUWebMovieVC;
    LMPropertyIUImportVC    *propertyIUImportVC;
    
    LMPropertyIUMailLinkVC  *propertyIUMailLinkVC;
    LMPropertyIUTextFieldVC *propertyPGTextFieldVC;
    LMPropertyIUCollectionVC  *propertyIUCollectionVC;
    
    LMPropertyIUTextViewVC *propertyPGTextViewVC;
    LMPropertyIUPageLinkSetVC *propertyPGPageLinkSetVC;
    LMPropertyIUPageVC * propertyIUPageVC;
    
    LMPropertyPGFormVC *propertyPGFormVC;
    LMPropertyIUTextVC *propertyIUTextVC;
    
    PGSubmitButtonVC *propertyPGSubmitButtonVC;
    
    LMPropertyProgrammingType1VC *propertyPGType1VC;
    LMPropertyProgrammingType2VC *propertyPGType2VC;
    
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
    LMPropertyTextVC *propertyTextVC;
#endif

    
    NSView *_noInspectorV;
    __weak NSTableView *_tableV;
}

@property     NSMutableArray *propertyVArray;


@property (strong) IBOutlet NSBox *defaultTitleV;
@property (strong) IBOutlet NSBox *advancedTitleV;
@property (strong) IBOutlet NSView *advancedContentV;

@property (weak) IBOutlet NSOutlineView *outlineV;
@property (weak) IBOutlet NSTextField *advancedTF;

@property (weak) IBOutlet NSTableView *tableV;
@property (strong) IBOutlet NSView *noInspectorV;
@end

@implementation LMIUPropertyVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _propertyVArray = [NSMutableArray array];
        
        inspectorLinkVC = [[LMInspectorLinkVC alloc] initWithNibName:[LMInspectorLinkVC class].className bundle:nil];
        propertyIUHTMLVC = [[LMPropertyIUHTMLVC alloc] initWithNibName:[LMPropertyIUHTMLVC class].className bundle:nil];
        
        propertyIUMovieVC = [[LMPropertyIUMovieVC alloc] initWithNibName:[LMPropertyIUMovieVC class].className bundle:nil];
        propertyIUFBLikeVC = [[LMPropertyIUFBLikeVC alloc] initWithNibName:[LMPropertyIUFBLikeVC class].className bundle:nil];
        propertyIUCarouselVC = [[LMPropertyIUcarouselVC alloc] initWithNibName:[LMPropertyIUcarouselVC class].className bundle:nil];
        
        propertyIUTransitionVC = [[LMPropertyIUTransitionVC alloc] initWithNibName:[LMPropertyIUTransitionVC class].className bundle:nil];
        propertyIUWebMovieVC = [[LMPropertyIUWebMovieVC alloc] initWithNibName:[LMPropertyIUWebMovieVC class].className bundle:nil];
        propertyIUImportVC = [[LMPropertyIUImportVC alloc] initWithNibName:[LMPropertyIUImportVC class].className bundle:nil];
        
        propertyIUMailLinkVC = [[LMPropertyIUMailLinkVC alloc] initWithNibName:[LMPropertyIUMailLinkVC class].className bundle:nil];

        propertyPGTextFieldVC = [[LMPropertyIUTextFieldVC alloc] initWithNibName:[LMPropertyIUTextFieldVC class].className bundle:nil];
        propertyIUCollectionVC = [[LMPropertyIUCollectionVC alloc] initWithNibName:[LMPropertyIUCollectionVC class].className bundle:nil];
        propertyPGTextViewVC = [[LMPropertyIUTextViewVC alloc] initWithNibName:[LMPropertyIUTextViewVC class].className bundle:nil];
        
        propertyPGPageLinkSetVC = [[LMPropertyIUPageLinkSetVC alloc] initWithNibName:[LMPropertyIUPageLinkSetVC class].className bundle:nil];
        propertyIUPageVC = [[LMPropertyIUPageVC alloc] initWithNibName:[LMPropertyIUPageVC class].className bundle:nil];
        propertyPGFormVC = [[LMPropertyPGFormVC alloc] initWithNibName:[LMPropertyPGFormVC class].className bundle:nil];
        
        propertyIUTextVC = [[LMPropertyIUTextVC alloc] initWithNibName:[LMPropertyIUTextVC class].className bundle:nil];
        
        propertyPGSubmitButtonVC = [[PGSubmitButtonVC alloc] initWithNibName:[PGSubmitButtonVC class].className bundle:nil];
        
        
        propertyPGType1VC = [[LMPropertyProgrammingType1VC alloc] initWithNibName:[LMPropertyProgrammingType1VC class].className bundle:nil];
        propertyPGType2VC = [[LMPropertyProgrammingType2VC alloc] initWithNibName:[LMPropertyProgrammingType2VC class].className bundle:nil];
        
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
        propertyTextVC = [[LMPropertyTextVC alloc] initWithNibName:[LMPropertyTextVC class].className bundle:nil];
#endif
        
        [self loadView];
    }
    return self;
}

-(void)awakeFromNib{
    [inspectorLinkVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUHTMLVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUMovieVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUFBLikeVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUCarouselVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUTransitionVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUWebMovieVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];

    [propertyIUImportVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyIUMailLinkVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyPGTextFieldVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUCollectionVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyPGTextViewVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyPGPageLinkSetVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUPageVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyPGFormVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    [propertyIUTextVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
    [propertyPGSubmitButtonVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
    
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
    [propertyTextVC bind:@"controller" toObject:self withKeyPath:@"controller" options:nil];
#endif
}

-(void)setProject:(IUProject *)project{
    _project = project;
    [inspectorLinkVC setProject:project];
    [propertyIUImportVC setProject:project];
}



-(void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
}

-(void)dealloc{
    //release 시점 확인용
    assert(0);
    //[_controller removeObserver:self forKeyPath:@"selectedObjects"];
}

- (void)setResourceManager:(IUResourceManager *)resourceManager{
    _resourceManager = resourceManager;
    propertyIUCarouselVC.resourceManager = resourceManager;
    propertyIUMovieVC.resourceManager = resourceManager;
}


-(void)selectedObjectsDidChange:(NSDictionary *)change{
    NSString *classString = [[self.controller selectedPedigree] firstObject];
    if ([classString isEqualToString:@"IUCarousel"]) {
        self.propertyVArray = nil;
        [_tableV setHidden:YES];
        [self.view addSubviewFullFrame:propertyIUCarouselVC.view];
    }
    else{
        [propertyIUCarouselVC.view removeFromSuperview];
        [_tableV setHidden:NO];
    }
    
#pragma mark PG
    if ([classString isEqualToString:@"PGForm"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyPGFormVC.view]];
    }
    else if ([classString isEqualToString:@"PGTextView"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyPGFormVC.view]];
    }
    else if ([classString isEqualToString:@"PGTextField"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyPGTextFieldVC.view, propertyPGType2VC.view]];
    }
    else if ([classString isEqualToString:@"PGSubmitButton"]){
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyPGSubmitButtonVC.view]];
    }
#pragma mark IU - Complex
    else if ([classString isEqualToString:@"IUMovie"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyIUMovieVC.view]];
    }
    else if ([classString isEqualToString:@"PGPageLinkSet"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyPGPageLinkSetVC.view]];
    }
    else if ([classString isEqualToString:@"IUWebMovie"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyIUWebMovieVC.view, propertyIUHTMLVC.view]];
    }
    else if ([classString isEqualToString:@"IUImport"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyIUImportVC.view, propertyPGType2VC.view]];
    }
    else if ([classString isEqualToString:@"IUMailLink"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyIUMailLinkVC.view]];
    }
    else if ([classString isEqualToString:@"IUTransition"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyIUTransitionVC.view]];
    }
    else if ([classString isEqualToString:@"IUFBLike"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyIUFBLikeVC.view]];
    }
#pragma mark IU-Simple
    else if ([classString isEqualToString:@"PGTextField"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyPGTextFieldVC.view, propertyPGType2VC.view]];
    }
    
    else if ([classString isEqualToString:@"IUBox"] || [classString isEqualToString:@"IUImage"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[inspectorLinkVC.view, propertyPGType1VC.view]];
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
        if([classString isEqualToString:@"IUBox"]){
            [self.propertyVArray addObject:propertyTextVC.view];
        }
        
    }
#else
    }
    else if ([classString isEqualToString:@"IUText"]) {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyIUTextVC.view, inspectorLinkVC.view, propertyPGType2VC.view]];
    }
#endif

    else if ([classString isEqualToString:@"IUHTML"]){
        self.propertyVArray = [NSMutableArray arrayWithArray:@[propertyIUHTMLVC.view]];
    }
    else {
        self.propertyVArray = [NSMutableArray arrayWithArray:@[self.noInspectorV]];
    }
    
    
    [_tableV reloadData];
}


#pragma mark -
#pragma mark tableView

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    id v = [self.propertyVArray objectAtIndex:row];
    if ([v isKindOfClass:[NSViewController class]]) {
        return [(NSViewController*)v view];
    }
    return v;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    return [self.propertyVArray count];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    if([self.propertyVArray count] == 0){
        return 0.1;
    }
    return [(NSView*)[self.propertyVArray objectAtIndex:row] frame].size.height;
}





@end
