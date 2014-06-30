//
//  LMStartPreviewWC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 30..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LMStartItem.h"

@interface LMStartPreviewWC : NSWindowController

+ (LMStartPreviewWC *)sharedStartPreviewWindow;
- (BOOL)loadStartItem:(LMStartItem *)item;

@end
