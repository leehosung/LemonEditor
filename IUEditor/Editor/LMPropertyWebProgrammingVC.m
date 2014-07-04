//
//  LMPropertyWebProgrammingVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 30..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyWebProgrammingVC.h"

@interface LMPropertyWebProgrammingVC ()

@property (weak) IBOutlet NSTextField *nameTF;

@end

@implementation LMPropertyWebProgrammingVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_nameTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"inputName"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];

}

@end
