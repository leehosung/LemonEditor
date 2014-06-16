//
//  LMPropertyShadowVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyShadowVC.h"

@interface LMPropertyShadowVC ()
@property (weak) IBOutlet NSColorWell *shadowColor;
@property (weak) IBOutlet NSSlider *shadowV;
@property (weak) IBOutlet NSSlider *shadowH;
@property (weak) IBOutlet NSSlider *shadowSprd;
@property (weak) IBOutlet NSSlider *shadowBlr;

@property (weak) IBOutlet NSTextField *shadowVText;
@property (weak) IBOutlet NSTextField *shadowHText;
@property (weak) IBOutlet NSTextField *shadowSpreadText;
@property (weak) IBOutlet NSTextField *shadowBlurText;


@end

@implementation LMPropertyShadowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (NSString*)CSSBindingPath:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}

-(void)awakeFromNib{

    [_shadowColor bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowColor] options:IUBindingDictNotRaisesApplicable];
    
    [_shadowV bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowVertical] options:IUBindingDictNotRaisesApplicable];
    [_shadowH bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowHorizontal] options:IUBindingDictNotRaisesApplicable];
    [_shadowSprd bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowSpread] options:IUBindingDictNotRaisesApplicable];
    [_shadowBlr bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowBlur] options:IUBindingDictNotRaisesApplicable];
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:0];
    [_shadowVText setFormatter:formatter];
    [_shadowHText setFormatter:formatter];
    [_shadowSpreadText setFormatter:formatter];
    [_shadowBlurText setFormatter:formatter];

    [_shadowVText bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowVertical] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_shadowHText bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowHorizontal] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_shadowSpreadText bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowSpread] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_shadowBlurText bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowBlur] options:@{NSNullPlaceholderBindingOption: @(0)}];
}
@end