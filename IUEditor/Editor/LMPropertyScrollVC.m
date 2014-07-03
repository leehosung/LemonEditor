//
//  LMPropertyScrollVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyScrollVC.h"
#import "LMHelpPopover.h"

@interface LMPropertyScrollVC ()

@property (weak) IBOutlet NSTextField *opacityMoveTF;
@property (weak) IBOutlet NSTextField *xPosMoveTF;


@end

@implementation LMPropertyScrollVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    
    [_opacityMoveTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"opacityMove"] options:IUBindingDictNotRaisesApplicable];
    [_xPosMoveTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"xPosMove"] options:IUBindingDictNotRaisesApplicable];

}
- (IBAction)clickHelpButton:(NSButton *)sender {
    LMHelpPopover *popover = [LMHelpPopover sharedHelpPopover];
    [popover setType:LMPopoverTypeTextAndVideo];
    [popover setVideoName:@"EventScrollAnimation.mp4" title:@"Scroll Event" rtfFileName:nil];
    [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
}
@end
