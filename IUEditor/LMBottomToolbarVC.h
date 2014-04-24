//
//  LMToolbarVC.h
//  IUEditor
//
//  Created by jd on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUResourceManager.h"
#import "IUDocument.h"

@interface LMBottomToolbarVC : NSViewController

@property (nonatomic) IUResourceManager     *resourceManager;
@property (nonatomic) IUDocument    *document;

@end
