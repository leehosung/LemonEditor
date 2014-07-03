//
//  LMHelpTextPopoverVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMHelpTextPopoverVC : NSViewController

- (void)setTitle:(NSString *)title rtfPath:(NSString *)rtfPath;
- (void)setTitle:(NSString *)title string:(NSString *)string;

@end
