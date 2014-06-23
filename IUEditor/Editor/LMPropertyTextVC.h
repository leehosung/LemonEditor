//
//  LMPropertyTextVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 20..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "LMIUPropertyVC.h"

@interface LMPropertyTextVC : NSViewController <IUPropertyDoubleClickReceiver>

@property (nonatomic) IUController      *controller;

@end
