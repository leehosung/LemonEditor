//
//  LMPropertyScrollVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMEventScrollAnimationVC.h"
#import "LMHelpPopover.h"

@interface LMEventScrollAnimationVC ()

@property (weak) IBOutlet NSTextField *opacityMoveTF;
@property (weak) IBOutlet NSTextField *xPosMoveTF;


@end

@implementation LMEventScrollAnimationVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    
    [_opacityMoveTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"opacityMove"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_xPosMoveTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"xPosMove"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToProperty:@"opacityMove"]  options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    id opacityMove = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"opacityMove"]];
    NSArray *selectedObj = [_controller selectedObjects ];
    if ([opacityMove isKindOfClass:[NSNumber class]]) {
        if ([opacityMove floatValue] > 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (IUBox *iu in selectedObj) {
                    iu.opacityMove = 1;
                }
            });
        }
    }
}

- (IBAction)clickHelpButton:(NSButton *)sender {
    LMHelpPopover *popover = [LMHelpPopover sharedHelpPopover];
    [popover setType:LMPopoverTypeTextAndVideo];
    [popover setVideoName:@"EventScrollAnimation.mp4" title:@"Scroll Event" rtfFileName:nil];
    [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
}
@end
