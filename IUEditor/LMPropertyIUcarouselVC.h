//
//  LMPropertyIUcarousel.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "IUResourceManager.h"


@interface LMPropertyIUcarouselVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic) IUController      *controller;
@property (nonatomic) IUResourceManager     *resourceManager;

@property (nonatomic) NSArray *imageArray;

@end
