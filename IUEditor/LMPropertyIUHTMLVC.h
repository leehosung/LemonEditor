//
//  LMPropertyIUHTMLVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "LMIUPropertyVC.h"

@interface LMPropertyIUHTMLVC : NSViewController <IUPropertyDoubleClickReceiver>

@property (nonatomic) IUController      *controller;

@end
