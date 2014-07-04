//
//  LMPropertyVTriggerVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMEventVariableTrigger.h"
#import "LMHelpPopover.h"

@interface LMEventVariableTrigger ()
@property (weak) IBOutlet NSTextField *variableTF;

@property (weak) IBOutlet NSTextField *initailValueTF;
@property (weak) IBOutlet NSStepper *initialValueStepper;
@property (weak) IBOutlet NSTextField *maxValueTF;
@property (weak) IBOutlet NSStepper *maxValueStepper;
@property (weak) IBOutlet NSPopUpButton *actionTypePopupButton;
@end

@implementation LMEventVariableTrigger

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_variableTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVariable] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_initailValueTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagInitialValue] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_initialValueStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagInitialValue] options:IUBindingDictNotRaisesApplicable];
    
    [_maxValueTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagMaxValue] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_maxValueStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagMaxValue] options:IUBindingDictNotRaisesApplicable];
    
    [_actionTypePopupButton bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagActionType] options:IUBindingDictNotRaisesApplicable];
    
}

- (IBAction)clickHelpButton:(NSButton *)sender {
    LMHelpPopover *popover = [LMHelpPopover sharedHelpPopover];
    [popover setType:LMPopoverTypeTextAndVideo];
    [popover setVideoName:@"EventVariableComplex.mp4" title:@"Variable Event" rtfFileName:nil];
    [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
}

@end
