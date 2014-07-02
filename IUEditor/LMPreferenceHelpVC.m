//
//  LMPreferenceHelpVC.m
//  IUEditor
//
//  Created by jd on 7/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPreferenceHelpVC.h"
#import "LMTutorialManager.h"

@interface LMPreferenceHelpVC ()

@end

@implementation LMPreferenceHelpVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)performResetHelp:(id)sender {
    [LMTutorialManager reset];
}

@end
