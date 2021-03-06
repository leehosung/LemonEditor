//
//  LMPropertyMouseEventVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMEventMouseOnVC.h"
#import "LMHelpPopover.h"

@interface LMEventMouseOnVC ()

//position
@property (weak) IBOutlet NSButton *changeBGImagePositionB;

@property (weak) IBOutlet NSStepper *bgXStepper;
@property (weak) IBOutlet NSStepper *bgYStepper;

@property (weak) IBOutlet NSTextField *bgXTF;
@property (weak) IBOutlet NSTextField *bgYTF;

//bgColor
@property (weak) IBOutlet NSButton *changeBGColorBtn;
@property (weak) IBOutlet NSColorWell *bgColorWell;

//textColor
@property (weak) IBOutlet NSButton *changeTextColorBtn;
@property (weak) IBOutlet NSColorWell *textColorWell;

@end

@implementation LMEventMouseOnVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{

#pragma mark bgX,Y
    
    NSDictionary *bgEnableBindingOption = [NSDictionary
                                           dictionaryWithObjects:@[NSIsNotNilTransformerName]
                                           forKeys:@[NSValueTransformerNameBindingOption]];
    
    NSDictionary *tfBindingOption = @{NSNullPlaceholderBindingOption: @(0), NSContinuouslyUpdatesValueBindingOption: @(YES)};
    
    [_changeBGImagePositionB bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    [_changeBGImagePositionB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:IUBindingDictNotRaisesApplicable];
    
 
    [_bgXTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:IUBindingDictNotRaisesApplicable];
    [_bgXTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageX] options:tfBindingOption];

    [_bgYTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:IUBindingDictNotRaisesApplicable];
    [_bgYTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageY] options:tfBindingOption];
    
    [_bgXStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:IUBindingDictNotRaisesApplicable];
    [_bgXStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageX] options:@{NSNullPlaceholderBindingOption:@(0)}];
    
    [_bgYStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:IUBindingDictNotRaisesApplicable];
    [_bgYStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageY] options:@{NSNullPlaceholderBindingOption:@(0)}];
    
#pragma mark bgColor
    [_changeBGColorBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGColorEnable] options:IUBindingDictNotRaisesApplicable];
    [_bgColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGColor] options:IUBindingDictNotRaisesApplicable];
    
#pragma mark textColor
    [_changeTextColorBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverTextColorEnable] options:IUBindingDictNotRaisesApplicable];
    [_textColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverTextColor] options:IUBindingDictNotRaisesApplicable];
   
}
- (IBAction)clickHelpButton:(NSButton *)sender {
    LMHelpPopover *popover = [LMHelpPopover sharedHelpPopover];
    [popover setType:LMPopoverTypeTextAndVideo];
    [popover setVideoName:@"EventMouseOn.mp4" title:@"Mouse On Event" rtfFileName:nil];
    [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
}

@end
