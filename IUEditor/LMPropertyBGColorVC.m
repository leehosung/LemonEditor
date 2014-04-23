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
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    [NSColor setIgnoresAlpha:NO];

    [_bgColorWell bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGColor] options:nil];
    [_bgGradientStartColorWell bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGGradientStartColor] options:nil];
    [_bgGradientEndColorWell bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGGradientEndColor] options:nil];


}

- (void)makeClearColor:(id)sender{
    [self setValue:nil forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGColor]];
}

@end
