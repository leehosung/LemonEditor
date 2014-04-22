//
//  LMPropertyIUTransitionVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUTransitionVC.h"

@interface LMPropertyIUTransitionVC ()
@property (weak) IBOutlet NSPopUpButton *currentEdit;
@property (weak) IBOutlet NSPopUpButton *eventB;
@property (weak) IBOutlet NSPopUpButton *animationB;
@property (weak) IBOutlet NSPopUpButton *opacityB;
@end

@implementation LMPropertyIUTransitionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_currentEdit bind:@"selectedIndex" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"currentEdit"] options:IUDictNotRaisesForNotApplicable];
//  [_eventB bind:@"selectedValue" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"event"] options:nil];
//    [_animationB bind:@"selectedValue" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"animation"] options:nil];
//    [_opacityB bind:@"selectedValue" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"opacity"] options:nil];

}

@end
