//
//  LMPropertyIUcarousel.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUcarouselVC.h"
#import "JDOutlineCellView.h"

@interface LMPropertyIUcarouselVC ()

//for outlineView
@property (strong) IBOutlet JDOutlineCellView *carouselMainView;
@property (strong) IBOutlet JDOutlineCellView *arrowView;
@property (strong) IBOutlet JDOutlineCellView *controlView;

//set attributes

@property (weak) IBOutlet NSMatrix *autoplayMatrix;
@property (weak) IBOutlet NSMatrix *arrowControlMatrix;
@property (weak) IBOutlet NSSegmentedControl *controllerSegmentedControl;

@property (weak) IBOutlet NSButton *enableColor;
@property (weak) IBOutlet NSColorWell *selectColor;
@property (weak) IBOutlet NSColorWell *deselectColor;
@property (weak) IBOutlet NSComboBox *leftImageComboBox;
@property (weak) IBOutlet NSComboBox *rightImageComboBox;
@property (weak) IBOutlet NSTextField *countTF;
@property (weak) IBOutlet NSStepper *countStepper;


@end

@implementation LMPropertyIUcarouselVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib{
    [_autoplayMatrix bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"autoplay"] options:IUBindingDictNotRaisesApplicable];
    [_arrowControlMatrix bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"disableArrowControl"] options:IUBindingDictNotRaisesApplicable];
    [_controllerSegmentedControl bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"controlType"] options:IUBindingDictNotRaisesApplicable];
    
    
    [_enableColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableColor"] options:IUBindingDictNotRaisesApplicable];
    [_selectColor bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableColor"] options:IUBindingDictNotRaisesApplicable];
    [_deselectColor bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableColor"] options:IUBindingDictNotRaisesApplicable];
    [_selectColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"selectColor"] options:IUBindingDictNotRaisesApplicable];
    [_deselectColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"deselectColor"] options:IUBindingDictNotRaisesApplicable];
    
    [_leftImageComboBox bind:NSContentBinding toObject:self withKeyPath:@"imageArray" options:IUBindingDictNotRaisesApplicable];
    [_rightImageComboBox bind:NSContentBinding toObject:self withKeyPath:@"imageArray" options:IUBindingDictNotRaisesApplicable];
    [_leftImageComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"leftArrowImage"] options:IUBindingDictNotRaisesApplicable];
    [_rightImageComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"rightArrowImage"] options:IUBindingDictNotRaisesApplicable];
    
    [_countStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"count"] options:IUBindingDictNotRaisesApplicable];
    [_countTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"count"] options:IUBindingDictNotRaisesApplicable];
    
    
    [self addObserver:self forKeyPath:@"resourceManager.imageFiles" options:NSKeyValueObservingOptionInitial context:@"image"];

}

- (void)dealloc{
    //release 시점 확인용
    assert(0);
}

//default Image 때문에 imageArray 사용 , resourceManager를 바로 호출하면 안됨.
-(void)imageContextDidChange:(NSDictionary *)change{
    self.imageArray = [@[@"Default"] arrayByAddingObjectsFromArray:self.resourceManager.imageFiles];
}

#pragma mark outlineview



- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if(item == nil){
        return 3;
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
        switch (index) {
            case 0:
                return _carouselMainView;
            case 1:
                return _arrowView.titleV;
            case 2:
                return _controlView.titleV;
            default:
                return nil;
        }
    }
    else{
        if([item isEqualTo:_arrowView.titleV]){
            return _arrowView.contentV;
        }
        else if([item isEqualTo:_controlView.titleV]){
            return _controlView.contentV;
        }
        else{
            return nil;
        }
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

- (IBAction)outlineViewClicked:(NSOutlineView *)sender{
    id clickItem = [sender itemAtRow:[sender clickedRow]];
    
    [sender isItemExpanded:clickItem] ?
    [sender.animator collapseItem:clickItem] : [sender.animator expandItem:clickItem];
}


@end
