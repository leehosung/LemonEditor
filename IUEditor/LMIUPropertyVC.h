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

@protocol IUPropertyDoubleClickReceiver <NSObject>
@required
- (void)performFocus:(NSNotification*)noti;

@end

@interface LMIUPropertyVC : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

- (void)setProject:(IUProject*)project;
- (void)setFocusForDoubleClickAction;

@property (nonatomic) IUController *controller;
@property (nonatomic) IUResourceManager     *resourceManager;

@end
