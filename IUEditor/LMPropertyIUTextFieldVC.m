//
//  LMPropertyIUTextFieldVC.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyIUTextFieldVC.h"

@interface LMPropertyIUTextFieldVC ()
@property (weak) IBOutlet NSTextField *nameTF;

@end

@implementation LMPropertyIUTextFieldVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_nameTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"formName"] options:nil];
}

@end
