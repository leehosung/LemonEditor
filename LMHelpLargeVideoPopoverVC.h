//
//  LMHelpLargeVideoPopoverVC.h
//  IUEditor
//
//  Created by seungmi on 2014. 7. 4..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface LMHelpLargeVideoPopoverVC : NSViewController
- (void)setVideoPath:(NSString *)videoPath title:(NSString *)title rtfPath:(NSString *)rtfPath;

@end
