//
//  LMPropertyVTriggerVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyVTriggerVC.h"

@interface LMPropertyVTriggerVC ()
@property (weak) IBOutlet NSTextField *variableTF;

@property (weak) IBOutlet NSTextField *initailValueTF;
@property (weak) IBOutlet NSStepper *initialValueStepper;
@property (weak) IBOutlet NSTextField *maxValueTF;
@property (weak) IBOutlet NSStepper *maxValueStepper;

@property (weak) IBOutlet NSComboBox *actionTypeComboBox;

@end

@implementation LMPropertyVTriggerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_variableTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVariable] options:IUBindingDictNotRaisesApplicable];
    
    [_initailValueTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagInitialValue] options:IUBindingDictNotRaisesApplicable];
    [_initialValueStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagInitialValue] options:IUBindingDictNotRaisesApplicable];
    
    [_maxValueTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagMaxValue] options:IUBindingDictNotRaisesApplicable];
    [_maxValueStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagMaxValue] options:IUBindingDictNotRaisesApplicable];
    
    [_actionTypeComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagActionType] options:IUBindingDictNotRaisesApplicable];
    
}
- (IBAction)clickActionTypeComboBox:(id)sender {
    NSInteger selectedIndex = [_actionTypeComboBox indexOfSelectedItem];
    [self setValue:@(selectedIndex) forKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagActionType]];
}



@end
