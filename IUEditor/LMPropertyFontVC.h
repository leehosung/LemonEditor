//
//  LMPropertyTextVC.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"

@interface LMPropertyFontVC : NSViewController <NSComboBoxDataSource, NSComboBoxDelegate>

@property (nonatomic) _binding_ IUController      *controller;

@end