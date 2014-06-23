//
//  LMStartNewDjangoVC.h
//  IUEditor
//
//  Created by jw on 5/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LMStartNewVC;

@interface LMStartNewDjangoVC : NSViewController
@property NSButton *nextB;
@property NSButton *prevB;


//Dir 설정
@property   LMStartNewVC    *parentVC;

- (void)show;

@end