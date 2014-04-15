//
//  LMPropertyBaseVC.h
//  IUEditor
//
//  Created by jd on 4/11/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"

@interface LMPropertyBaseVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic) IUController *controller;
@property (copy) NSArray *pageDocumentNodes;
@property (copy) NSArray *masterDocumentNodes;

@end
