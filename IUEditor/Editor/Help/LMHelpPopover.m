//
//  LMHelpPopover.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMHelpPopover.h"
#import "LMHelpImagePopoverVC.h"
#import "LMHelpTextPopoverVC.h"
#import "LMHelpVideoPopoverVC.h"
#import "LMHelpLargeVideoPopoverVC.h"


static LMHelpPopover *gHelpPopover = nil;

@implementation LMHelpPopover{
    LMHelpImagePopoverVC    *imagePopoverVC;
    LMHelpTextPopoverVC     *textPopoverVC;
    LMHelpVideoPopoverVC    *videoPopoverVC;
    LMHelpLargeVideoPopoverVC *largeVideoPopoverVC;
    BOOL isSetting;
}

+(LMHelpPopover *)sharedHelpPopover{
    if(gHelpPopover == nil){
        gHelpPopover = [[LMHelpPopover alloc] init];
    }
    return gHelpPopover;
}


- (id)init{
    self = [super init];
    if(self){
        self.appearance = NSPopoverAppearanceHUD;
        self.animates = YES;
        self.behavior = NSPopoverBehaviorTransient;
        
        imagePopoverVC = [[LMHelpImagePopoverVC alloc] initWithNibName:[LMHelpImagePopoverVC class].className bundle:nil];
        textPopoverVC = [[LMHelpTextPopoverVC alloc] initWithNibName:[LMHelpTextPopoverVC class].className bundle:nil];
        videoPopoverVC = [[LMHelpVideoPopoverVC alloc] initWithNibName:[LMHelpVideoPopoverVC class].className bundle:nil];
        largeVideoPopoverVC = [[LMHelpLargeVideoPopoverVC alloc] initWithNibName:[LMHelpLargeVideoPopoverVC class].className bundle:nil];
        
        self.contentViewController = textPopoverVC;
        
    }
    return self;
}

- (void)setType:(LMPopoverType)type{
    _type = type;
    switch (type) {
        case LMPopoverTypeText:
            self.contentViewController = textPopoverVC;
            break;
        case LMPopoverTypeTextAndImage:
            self.contentViewController = imagePopoverVC;
            break;
        case LMPopoverTypeTextAndVideo:
            self.contentViewController = videoPopoverVC;
            break;
        case LMPopoverTypeTextAndLargeVideo:
            self.contentViewController = largeVideoPopoverVC;
            break;
        default:
            assert(0);
            break;
    }
}
#pragma mark - Video

- (void)setVideoName:(NSString *)videoName title:(NSString *)title rtfFileName:(NSString *)rtfFileName{
    if(_type == LMPopoverTypeTextAndVideo || _type == LMPopoverTypeTextAndLargeVideo){
        NSString *rtfPath, *videoPath;
        
        if(rtfFileName){
             rtfPath = [[NSBundle mainBundle] pathForResource:[rtfFileName stringByDeletingPathExtension] ofType:[rtfFileName pathExtension]];
        }
        if(videoName){
             videoPath = [[NSBundle mainBundle] pathForResource:[videoName stringByDeletingPathExtension] ofType:[videoName pathExtension]];
        }
        
        [videoPopoverVC setVideoPath:videoPath title:title rtfPath:rtfPath];
        [largeVideoPopoverVC setVideoPath:videoPath title:title rtfPath:rtfPath];
        
        isSetting = YES;
    }
}

#pragma mark - Image

- (void)setImage:(NSImage *)image title:(NSString *)title subTitle:(NSString *)subTitle rtfFileName:(NSString *)rtfFileName{
    if(_type == LMPopoverTypeTextAndImage){
        NSString *rtfPath;
        
        if(rtfFileName){
            rtfPath= [[NSBundle mainBundle] pathForResource:[rtfFileName stringByDeletingPathExtension] ofType:[rtfFileName pathExtension]];
        }
        
        [imagePopoverVC setImage:image title:title subTitle:subTitle rtfPath:rtfPath];
        isSetting = YES;
    }
    
}
- (void)setImage:(NSImage *)image title:(NSString *)title subTitle:(NSString *)subTitle text:(NSString *)text{
    if(_type == LMPopoverTypeTextAndImage){
        [imagePopoverVC setImage:image title:title subTitle:subTitle text:text];
        isSetting = YES;
    }
    
}

#pragma mark - Text

- (void)setTitle:(NSString *)title rtfFileName:(NSString *)rtfFileName{
    if(_type == LMPopoverTypeText){
        NSString *rtfPath;
        
        if(rtfFileName){
            rtfPath = [[NSBundle mainBundle] pathForResource:[rtfFileName stringByDeletingPathExtension] ofType:[rtfFileName pathExtension]];
        }
        [textPopoverVC setTitle:title rtfPath:rtfPath];
        isSetting = YES;
    }
}

- (void)setTitle:(NSString *)title text:(NSString *)text{
    if(_type == LMPopoverTypeText){
        [textPopoverVC setTitle:title string:text];
        isSetting = YES;
    }
}


#pragma mark override popover
- (void)showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge{
    if(isSetting){
        [super showRelativeToRect:positioningRect ofView:positioningView preferredEdge:preferredEdge];
    }
}

- (void)close{
    isSetting = NO;
    [super close];
    
}


@end
