//
//  LMPropertyIUcarousel.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUcarouselVC.h"

@interface LMPropertyIUcarouselVC ()

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

@end
