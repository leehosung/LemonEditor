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
    [_shadowColor bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowColor] options:nil];
    [_shadowV bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowVertical] options:nil];
    [_shadowH bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowHorizontal] options:nil];
    [_shadowSprd bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowSpread] options:nil];
    [_shadowBlr bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagShadowBlur] options:nil];
}
@end