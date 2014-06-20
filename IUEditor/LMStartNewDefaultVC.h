//
//  LMStartNewDefaultVC.h
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LMStartNewVC;

@interface LMStartNewDefaultVC : NSViewController
@property NSButton *nextB;
@property NSButton *prevB;

- (void)show;
@property   LMStartNewVC    *parentVC;

@end