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
}LMPopoverType;

@interface LMHelpPopover : NSPopover

@property (nonatomic) LMPopoverType type;

+(LMHelpPopover *)sharedHelpPopover;

//function to set content

//type : LMPopoverTypeTextAndVideo
- (void)setVideoName:(NSString *)imageName title:(NSString *)title rtfFileName:(NSString *)rtfFileName;
//type : LMPopoverTextAndImage
- (void)setImage:(NSImage *)image title:(NSString *)title rtfFileName:(NSString *)rtfFileName;
//type : LMPopoverText
- (void)setTitle:(NSString *)title rtfFileName:(NSString *)rtfFileName;

/*** How To Use Popover ***
 
 sharedPopover를 호출,
 원하는 popover 타입을 설정
 각각 해당하는 함수로 popover contents를 설정
 popover show함수 호출
 
 example)
 LMHelpPopover *popover = [LMHelpPopover sharedHelpPopover];
 [popover setType:LMPopoverTypeTextAndImage];
 [popover setImage:object.image title:object.title rtfFileName:nil];
 [popover showRelativeToRect:[targetView bounds] ofView:sender preferredEdge:NSMaxYEdge];

 */

@end
