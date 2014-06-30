//
//  LMPropertyBGColorVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyBGColorVC.h"

@interface LMPropertyBGColorVC ()

@property (weak) IBOutlet NSColorWell *bgColorWell;
@property (weak) IBOutlet NSColorWell *bgGradientStartColorWell;
@property (weak) IBOutlet NSColorWell *bgGradientEndColorWell;
@property (weak) IBOutlet NSButton *enableGradientBtn;

@end

@implementation LMPropertyBGColorVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
//    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    [NSColor setIgnoresAlpha:NO];

    [_bgColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGColor] options:IUBindingDictNotRaisesApplicable];
    
    //gradient
    [_enableGradientBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGGradient] options:IUBindingDictNotRaisesApplicable];
    
    [_bgGradientStartColorWell bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGGradient] options:IUBindingDictNotRaisesApplicable];
    [_bgGradientEndColorWell bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGGradient] options:IUBindingDictNotRaisesApplicable];
    
    [_bgGradientStartColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGGradientStartColor] options:IUBindingDictNotRaisesApplicable];
    [_bgGradientEndColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGGradientEndColor] options:IUBindingDictNotRaisesApplicable];


}

- (void)makeClearColor:(id)sender{
    [self setValue:nil forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGColor]];
}
- (IBAction)clickEnableGradient:(id)sender {
    if([_enableGradientBtn state]){
        id currentColor = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGColor]];
        [self setValue:currentColor forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGGradientStartColor]];
        [self setValue:currentColor forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGGradientEndColor]];

    }
    else{
        [_bgGradientStartColorWell deactivate];
        [_bgGradientEndColorWell deactivate];
    }
}

@end
