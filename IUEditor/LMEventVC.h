//
//  LMEventVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"

@interface LMEventVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic) IUController  *controller;

@end
