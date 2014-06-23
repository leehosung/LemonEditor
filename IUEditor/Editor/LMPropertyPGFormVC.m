//
//  LMPropertyIUFormVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyPGFormVC.h"

@interface LMPropertyPGFormVC ()
@property (weak) IBOutlet NSComboBox *submitPageComboBox;

@end

@implementation LMPropertyPGFormVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)performFocus:(NSNotification *)noti{
    [self.view.window makeFirstResponder:_submitPageComboBox];
}

@end
