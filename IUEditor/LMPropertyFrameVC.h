//
//  LMPropertyVC.h
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"


@interface LMPropertyFrameVC : NSViewController <NSTextFieldDelegate>

@property (nonatomic) IUController *controller;

@end