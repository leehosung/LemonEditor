//
//  LMPropertyVisibleVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyVisibleVC.h"

@interface LMPropertyVisibleVC ()
@property (weak) IBOutlet NSTextField *equationTF;
@property (weak) IBOutlet NSTextField *durationTF;
@property (weak) IBOutlet NSStepper *durationStepper;
@property (weak) IBOutlet NSPopUpButton *visibleTypePopupBtn;
@property NSArray *typeArray;

@end

@implementation LMPropertyVisibleVC{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    
    [_equationTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVisibleEquation] options:IUBindingDictNotRaisesApplicable];
    [_durationTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVisibleDuration] options:IUBindingDictNotRaisesApplicable];
    [_durationStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVisibleDuration] options:IUBindingDictNotRaisesApplicable];
    _typeArray = [IUEvent visibleTypeArray];
    [_visibleTypePopupBtn bind:NSContentBinding toObject:self withKeyPath:@"typeArray" options:IUBindingDictNotRaisesApplicable];
    
    [_visibleTypePopupBtn bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVisibleType] options:IUBindingDictNotRaisesApplicable];
}


@end
