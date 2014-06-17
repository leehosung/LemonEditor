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
#import "LMInspectorLinkVC.h"

@interface LMIUPropertyVC : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic) IUController *controller;
@property (nonatomic) IUResourceManager     *resourceManager;
@property (nonatomic) NSArray   *pageDocuments;
@property (nonatomic) NSArray   *classDocuments;

@end
