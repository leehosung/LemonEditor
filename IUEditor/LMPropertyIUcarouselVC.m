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


@end

@implementation LMPropertyIUcarouselVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageArray = [NSArray arrayWithObject:@"Default"];
    }
    return self;
}

-(void)awakeFromNib{
    [_autoplayMatrix bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"autoplay"] options:IUBindingDictNotRaisesApplicable];
    [_arrowControlMatrix bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"disableArrowControl"] options:IUBindingDictNotRaisesApplicable];
    [_controllerSegmentedControl bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"controlType"] options:IUBindingDictNotRaisesApplicable];
    
    
    [_enableColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableColor"] options:IUBindingDictNotRaisesApplicable];
    [_selectColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"selectColor"] options:IUBindingDictNotRaisesApplicable];
    [_deselectColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"deselectColor"] options:IUBindingDictNotRaisesApplicable];
    
    [_leftImageComboBox bind:NSContentBinding toObject:self withKeyPath:@"imageArray" options:IUBindingDictNotRaisesApplicable];
    [_rightImageComboBox bind:NSContentBinding toObject:self withKeyPath:@"imageArray" options:IUBindingDictNotRaisesApplicable];
    [_leftImageComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"leftArrowImage"] options:IUBindingDictNotRaisesApplicable];
    [_rightImageComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"rightArrowImage"] options:IUBindingDictNotRaisesApplicable];
    
    
    [self addObserver:self forKeyPath:@"resourceManager.imageNames" options:NSKeyValueObservingOptionInitial context:@"image"];
}

-(void)imageContextDidChange:(NSDictionary *)change{
    [self willChangeValueForKey:@"imageArray"];
    _imageArray = [@[@"Default"] arrayByAddingObjectsFromArray:self.resourceManager.imageNames];
    [self didChangeValueForKey:@"imageArray"];
}

@end
