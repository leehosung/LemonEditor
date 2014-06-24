//
//  LMPropertyIURenderVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"

@interface LMPropertyIUImportVC : NSViewController

@property (nonatomic) IUController      *controller;
@property IUSheet *selectedClass;

- (void)setProject:(IUProject*)project;

@end
