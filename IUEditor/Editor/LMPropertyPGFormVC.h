//
//  LMPropertyIUFormVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "LMIUPropertyVC.h"

@interface LMPropertyPGFormVC : NSViewController <NSComboBoxDelegate, IUPropertyDoubleClickReceiver>

@property (nonatomic) IUController      *controller;

- (void)setProject:(IUProject*)project;

@end
