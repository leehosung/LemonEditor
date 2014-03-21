//
//  LMStackCellV.h
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LMStackVC.h"

@interface LMStackCellV : NSTableCellView

@property NSString  *text;
@property NSImage   *image;
@property LMStackVC  *stackVC;

@end
