//
//  LMPropertyIUTextFieldVC.h
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "LMIUPropertyVC.h"

@interface LMPropertyIUTextFieldVC : NSViewController <IUPropertyDoubleClickReceiver>
@property (weak, nonatomic) IUController *controller;
@end
