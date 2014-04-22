//
//  LMPropertyMouseEventVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyMouseEventVC.h"

@interface LMPropertyMouseEventVC ()
@property (weak) IBOutlet NSButton *changeBGImagePositionB;
@property (weak) IBOutlet NSTextField *bgXTF;
@property (weak) IBOutlet NSTextField *bgYTF;
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
    [_changeBGImagePositionB bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    [_bgXTF bind:@"enabled" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    [_bgXTF bind:@"editable" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];

    [_bgYTF bind:@"enabled" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    [_bgYTF bind:@"editable" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImagePositionEnable] options:nil];
    
    [_bgXTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageX] options:@{NSNullPlaceholderBindingOption:@(0)}];
    [_bgYTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHoverBGImageY] options:@{NSNullPlaceholderBindingOption:@(0)}];
}

@end
