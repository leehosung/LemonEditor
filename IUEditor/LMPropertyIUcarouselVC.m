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

@property (weak) IBOutlet NSColorWell *selectColor;
@property (weak) IBOutlet NSColorWell *deselectColor;

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
    [_selectColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"selectColor"] options:IUBindingDictNotRaisesApplicable];
    [_deselectColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"deselectColor"] options:IUBindingDictNotRaisesApplicable];
}

@end
