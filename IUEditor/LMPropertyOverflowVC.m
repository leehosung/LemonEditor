//
//  LMPropertyOverflowVC.m
//  IUEditor
//
//  Created by G on 2014. 6. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyOverflowVC.h"
#import "IUBox.h"
#import "IUCSS.h"

@interface LMPropertyOverflowVC ()
@property (weak) IBOutlet NSPopUpButton *overflowPopupBtn;

@end

@implementation LMPropertyOverflowVC

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
    [_overflowPopupBtn bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"overflowType"] options:nil];
 //   [_overflowB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"overflow"] options:IUBindingDictNotRaisesApplicable];
    [_overflowPopupBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeOverflow"] options:IUBindingDictNotRaisesApplicable];
}




@end
