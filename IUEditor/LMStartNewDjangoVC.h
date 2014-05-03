//
//  LMStartNewDjangoVC.h
//  IUEditor
//
//  Created by jw on 5/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMStartNewDjangoVC : NSViewController
@property NSButton *nextB;

//Dir 설정
@property   NSString    *appDirPath;
@property   NSString    *imgDirPath;
@property   NSString    *templateDirPath;

- (void)show;

@end
