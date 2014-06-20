//
//  LMPropertyIUTransitionVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUTransitionVC.h"

@interface LMPropertyIUTransitionVC ()
@property (weak) IBOutlet NSPopUpButton *eventB;
@property (weak) IBOutlet NSPopUpButton *animationB;

@property NSArray *typeArray;

@end

@implementation LMPropertyIUTransitionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_eventB bind:NSSelectedValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"eventType"] options:IUBindingDictNotRaisesApplicable];
    [_animationB bind:NSSelectedValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"animation"] options:IUBindingDictNotRaisesApplicable];
    _typeArray = [IUEvent visibleTypeArray];
    
    [_animationB bind:NSContentBinding toObject:self withKeyPath:@"typeArray" options:IUBindingDictNotRaisesApplicable];
}

@end
