//
//  LMPropertyIUTextVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUTextVC.h"

@interface LMPropertyIUTextVC ()
@property (weak) IBOutlet NSTextField *textVariableTF;
@property (weak) IBOutlet NSMatrix *textTypeMatrix;
@end

@implementation LMPropertyIUTextVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)awakeFromNib{
    
    [_textVariableTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"textVariable"] options:IUBindingDictNotRaisesApplicable];
    [_textTypeMatrix bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"textType"] options:IUBindingDictNotRaisesApplicable];
}

@end
