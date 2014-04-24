//
//  LMIUInspectorVC.h
//  IUEditor
//
//  Created by jd on 4/11/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "IUResourceManager.h"
#import "LMPropertyIUBoxVC.h"

@interface LMIUInspectorVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic) IUController *controller;
@property (nonatomic) IUResourceManager     *resourceManager;
@property (nonatomic) NSArray   *pageDocumentNodes;
@property (nonatomic) NSArray   *classDocumentNodes;

@end
