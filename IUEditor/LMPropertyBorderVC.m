//
//  LMPropertyApperenceVC.m
//  IUEditor
//
//  Created by jd on 4/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyBorderVC.h"
#import "JDTransformer.h"

@interface LMPropertyBorderVC ()

@property (weak) IBOutlet NSTextField *borderTF;
@property (weak) IBOutlet NSTextField *borderTopTF;
@property (weak) IBOutlet NSTextField *borderRightTF;
@property (weak) IBOutlet NSTextField *borderLeftTF;
@property (weak) IBOutlet NSTextField *borderBottomTF;

@property (weak) IBOutlet NSStepper *borderStepper;
@property (weak) IBOutlet NSStepper *borderTopStepper;
@property (weak) IBOutlet NSStepper *borderBottomStepper;
@property (weak) IBOutlet NSStepper *borderLeftStepper;
@property (weak) IBOutlet NSStepper *borderRightStepper;

@property (weak) IBOutlet NSColorWell *borderColorWell;
@property (weak) IBOutlet NSColorWell *borderTopColorWell;
@property (weak) IBOutlet NSColorWell *borderLeftColorWell;
@property (weak) IBOutlet NSColorWell *borderRightColorWell;
@property (weak) IBOutlet NSColorWell *borderBottomColorWell;

@property (weak) IBOutlet NSTextField *borderRadiusTF;
@property (weak) IBOutlet NSTextField *borderRadiusTopLeftTF;
@property (weak) IBOutlet NSTextField *borderRadiusTopRightTF;
@property (weak) IBOutlet NSTextField *borderRadiusBottomLeftTF;
@property (weak) IBOutlet NSTextField *borderRadiusBottomRightTF;

@property (weak) IBOutlet NSStepper *borderRadiusStepper;
@property (weak) IBOutlet NSStepper *borderRadiusTopLeftStepper;
@property (weak) IBOutlet NSStepper *borderRadiusTopRightStepper;
@property (weak) IBOutlet NSStepper *borderRadiusBottomLeftStepper;
@property (weak) IBOutlet NSStepper *borderRadiusBottomRightStepper;

@end



@implementation LMPropertyBorderVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)setController:(IUController *)controller{
    _controller = controller;
    NSDictionary *bindingOption = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO], @"JDNilToZeroTransformer"]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption,  NSValueTransformerNameBindingOption]];

    [_borderColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderColor] options:IUBindingDictNotRaisesApplicable];
    [_borderTopColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderTopColor]  options:IUBindingDictNotRaisesApplicable];
    [_borderLeftColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderLeftColor] options:IUBindingDictNotRaisesApplicable];
    [_borderRightColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRightColor] options:IUBindingDictNotRaisesApplicable];
    [_borderBottomColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderBottomColor] options:IUBindingDictNotRaisesApplicable];
    
    [_borderTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderWidth] options:bindingOption];
    [_borderTopTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderTopWidth] options:bindingOption];
    [_borderBottomTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderBottomWidth] options:bindingOption];
    [_borderLeftTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderLeftWidth] options:bindingOption];
    [_borderRightTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRightWidth] options:bindingOption];
    
    
    [_borderStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderWidth] options:bindingOption];
    [_borderTopStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderTopWidth] options:bindingOption];
    [_borderBottomStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderBottomWidth] options:bindingOption];
    [_borderLeftStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderLeftWidth] options:bindingOption];
    [_borderRightStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRightWidth] options:bindingOption];
    
    [_borderRadiusTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadius] options:bindingOption];
    [_borderRadiusTopLeftTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusTopLeft] options:bindingOption];
    [_borderRadiusTopRightTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusTopRight] options:bindingOption];
    [_borderRadiusBottomLeftTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusBottomLeft] options:bindingOption];
    [_borderRadiusBottomRightTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusBottomRight] options:bindingOption];

    [_borderRadiusStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadius] options:bindingOption];
    [_borderRadiusTopLeftStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusTopLeft] options:bindingOption];
    [_borderRadiusTopRightStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusTopRight] options:bindingOption];
    [_borderRadiusBottomLeftStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusBottomLeft] options:bindingOption];
    [_borderRadiusBottomRightStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusBottomRight] options:bindingOption];

}
- (IBAction)clickBorderColorWell:(id)sender {
    id selectedColor = [_borderColorWell color];
    
    [self setValue:selectedColor forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderTopColor]];
    [self setValue:selectedColor forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderBottomColor]];
    [self setValue:selectedColor forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderLeftColor]];
    [self setValue:selectedColor forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRightColor]];

    

}
- (IBAction)clickBorderTotalSize:(id)sender {
    int selectedSize;
    if([sender isKindOfClass:[NSTextField class]]){
        selectedSize = [_borderTF intValue];
        [_borderStepper setIntValue:selectedSize];
    }
    else{
        selectedSize = [_borderStepper intValue];
        [_borderTF setIntValue:selectedSize];
    }
    
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderTopWidth]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderBottomWidth]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderLeftWidth]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRightWidth]];
    
}

- (IBAction)clickBorderRadiusTotalSize:(id)sender {
    int selectedSize;
    if([sender isKindOfClass:[NSTextField class]]){
        selectedSize = [_borderRadiusTF intValue];
        [_borderRadiusStepper setIntValue:selectedSize];
    }
    else{
        selectedSize = [_borderRadiusStepper intValue];
        [_borderRadiusTF setIntValue:selectedSize];
    }
    
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusTopLeft]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusTopRight]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusBottomLeft]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusBottomRight]];

}

@end