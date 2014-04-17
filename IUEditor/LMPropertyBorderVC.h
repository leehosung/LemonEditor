//
//  LMPropertyApperenceVC.h
//  IUEditor
//
//  Created by jd on 4/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"

@interface LMPropertyBorderVC : NSViewController
@property (nonatomic) IUController      *controller;

@property (weak) IBOutlet NSBox *borderTitleV;
@property (weak) IBOutlet NSBox *borderContentV;

@end