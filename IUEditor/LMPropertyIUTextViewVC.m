//
//  LMPropertyIUTextViewVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 5..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUTextViewVC.h"

@interface LMPropertyIUTextViewVC ()
@property (weak) IBOutlet NSTextField *placeholderTF;
@property (weak) IBOutlet NSTextField *valueTF;

@end

@implementation LMPropertyIUTextViewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_placeholderTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"placeholder"] options:IUBindingDictNotRaisesApplicable];
    [_valueTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"inputValue"] options:IUBindingDictNotRaisesApplicable];
}

@end
