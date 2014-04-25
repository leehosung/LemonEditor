//
//  LMPropertyVRFrameVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyVRFrameVC.h"

@interface LMPropertyVRFrameVC ()
@property (weak) IBOutlet NSTextField *equationTF;
@property (weak) IBOutlet NSTextField *durationTF;
@property (weak) IBOutlet NSStepper *durationStepper;
@property (weak) IBOutlet NSTextField *widthTF;
@property (weak) IBOutlet NSTextField *heightTF;

@end

@implementation LMPropertyVRFrameVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib{
    
    
    [_equationTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagFrameEquation] options:IUBindingDictNotRaisesApplicable];
    [_durationTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagFrameDuration] options:IUBindingDictNotRaisesApplicable];
    [_durationStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagFrameDuration] options:IUBindingDictNotRaisesApplicable];
    
    [_widthTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagFrameWidth] options:IUBindingDictNotRaisesApplicable];
    [_heightTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToEventTag:IUEventTagFrameHeight] options:IUBindingDictNotRaisesApplicable];

}



@end
