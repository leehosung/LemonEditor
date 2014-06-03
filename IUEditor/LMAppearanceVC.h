//
//  LMAppearanceVC.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "LMPropertyBGImageVC.h"


@interface LMAppearanceVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic) IUController      *controller;
@property (nonatomic) IUResourceManager *resourceManager;

//setResourceManager
@property LMPropertyBGImageVC    *propertyBGImageVC;

@end
