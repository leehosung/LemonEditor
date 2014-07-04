//
//  LMPropertyVisibleVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMEventVariableReceiverVC.h"
#import "LMHelpPopover.h"

@interface LMEventVariableReceiverVC ()
@property (weak) IBOutlet NSTextField *equationTF;
@property (weak) IBOutlet NSTextField *durationTF;
@property (weak) IBOutlet NSStepper *durationStepper;
@property (weak) IBOutlet NSPopUpButton *visibleTypePopupBtn;
@property NSArray *typeArray;

@end

@implementation LMEventVariableReceiverVC{
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
    
    NSDictionary *numberBindingOption = @{NSRaisesForNotApplicableKeysBindingOption:@(NO),NSValueTransformerNameBindingOption:@"JDNilToZeroTransformer", NSContinuouslyUpdatesValueBindingOption : @(YES)};

    
    [_equationTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVisibleEquation] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_durationTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVisibleDuration] options:numberBindingOption];
    [_durationStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVisibleDuration] options:numberBindingOption];
    _typeArray = [IUEvent visibleTypeArray];
    [_visibleTypePopupBtn bind:NSContentBinding toObject:self withKeyPath:@"typeArray" options:IUBindingDictNotRaisesApplicable];
    
    [_visibleTypePopupBtn bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagVisibleType] options:IUBindingDictNotRaisesApplicable];
}

- (IBAction)clickHelpButton:(NSButton *)sender {
    LMHelpPopover *popover = [LMHelpPopover sharedHelpPopover];
    [popover setType:LMPopoverTypeTextAndVideo];
    [popover setVideoName:@"EventVariableComplex.mp4" title:@"Variable Event" rtfFileName:nil];
    [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
}

@end
