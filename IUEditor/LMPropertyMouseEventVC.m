//
//  LMPropertyMouseEventVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyMouseEventVC.h"

@interface LMPropertyMouseEventVC ()

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

@implementation LMPropertyMouseEventVC

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
    [_changeBGImagePositionB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    
    [_bgXTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    [_bgXTF bind:NSEditableBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    [_bgXTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageX] options:@{NSNullPlaceholderBindingOption:@(0)}];

    [_bgYTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    [_bgYTF bind:NSEditableBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    [_bgYTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageY] options:@{NSNullPlaceholderBindingOption:@(0)}];
    
    [_bgXStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    [_bgXStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageX] options:@{NSNullPlaceholderBindingOption:@(0)}];
    
    [_bgYStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    [_bgYStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageY] options:@{NSNullPlaceholderBindingOption:@(0)}];
    
#pragma mark bgColor
    [_changeBGColorBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGColorEnable] options:nil];
    [_bgColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGColor] options:nil];
    
#pragma mark textColor
    [_changeTextColorBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverTextColorEnable] options:nil];
    [_textColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverTextColor] options:nil];
   
}

@end
