//
//  LMHelpPopover.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum{
    LMPopoverTypeText,
    LMPopoverTypeTextAndImage,
    LMPopoverTypeTextAndVideo,
    LMPopoverTypeTextAndLargeVideo
}LMPopoverType;

@interface LMHelpPopover : NSPopover

@property (nonatomic) LMPopoverType type;

/**
 Get singleton instance of class
 @code
 LMHelpPopover *popover = [LMHelpPopover sharedHelpPopover];
 [popover setType:LMPopoverTypeTextAndImage];
 [popover setImage:object.image title:object.title rtfFileName:nil];
 [popover showRelativeToRect:[targetView bounds] ofView:sender preferredEdge:NSMaxYEdge];
 */

+(LMHelpPopover *)sharedHelpPopover;

//function to set content
//type : LMPopoverTypeTextAndVideo
- (void)setVideoName:(NSString *)videoName title:(NSString *)title rtfFileName:(NSString *)rtfFileName;
//type : LMPopoverTextAndImage
- (void)setImage:(NSImage *)image title:(NSString *)title subTitle:(NSString *)subTitle rtfFileName:(NSString *)rtfFileName;
- (void)setImage:(NSImage *)image title:(NSString *)title subTitle:(NSString *)subTitle text:(NSString *)text;
//type : LMPopoverText
- (void)setTitle:(NSString *)title rtfFileName:(NSString *)rtfFileName;
- (void)setTitle:(NSString *)title text:(NSString *)text;
@end
