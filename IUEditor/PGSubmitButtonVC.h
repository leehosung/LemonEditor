//
//  PGSubmitButtonVC.h
//  IUEditor
//
//  Created by Geunmin.Moon on 2014. 6. 10..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "LMIUPropertyVC.h"

@interface PGSubmitButtonVC : NSViewController <IUPropertyDoubleClickReceiver>

@property (nonatomic) IUController      *controller;

@end
