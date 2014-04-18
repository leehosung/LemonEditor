//
//  LMIUInspectorVC.h
//  IUEditor
//
//  Created by jd on 4/11/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "LMPropertyIUBoxVC.h"

@interface LMIUInspectorVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic) IUController *controller;

//Connect to LMWC
@property  LMPropertyIUBoxVC   *propertyIUBoxVC;

@end
