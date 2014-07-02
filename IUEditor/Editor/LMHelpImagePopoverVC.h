//
//  LMHelpPopoverVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMHelpImagePopoverVC : NSViewController

- (void)setImage:(NSImage *)image title:(NSString *)title subTitle:(NSString *)subTitle rtfPath:(NSString *)rtfPath;
- (void)setImage:(NSImage *)image title:(NSString *)title subTitle:(NSString *)subTitle text:(NSString *)text;

@end
