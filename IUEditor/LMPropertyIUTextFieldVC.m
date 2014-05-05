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
@property (weak) IBOutlet NSTextField *placeholderTF;
@property (weak) IBOutlet NSTextField *valueTF;
@property (weak) IBOutlet NSMatrix *typeMatrix;


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
    [_nameTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"formName"] options:IUBindingDictNotRaisesApplicable];
    [_placeholderTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"placeholder"] options:IUBindingDictNotRaisesApplicable];
    [_valueTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"inputValue"] options:IUBindingDictNotRaisesApplicable];
    [_typeMatrix bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"type"] options:IUBindingDictNotRaisesApplicable];
}

@end
