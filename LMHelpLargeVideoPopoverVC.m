//
//  LMHelpLargeVideoPopoverVC.m
//  IUEditor
//
//  Created by seungmi on 2014. 7. 4..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMHelpLargeVideoPopoverVC.h"

@interface LMHelpLargeVideoPopoverVC ()

@property (weak) IBOutlet AVPlayerView *videoView;
@property (unsafe_unretained) IBOutlet NSTextView *textV;
@property (weak) IBOutlet NSTextField *titleTF;

@end

@implementation LMHelpLargeVideoPopoverVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self loadView];
    }
    return self;
}
- (void)setVideoPath:(NSString *)videoPath title:(NSString *)title rtfPath:(NSString *)rtfPath{
    
    [_titleTF setStringValue:title];
    if(rtfPath){
        [_textV readRTFDFromFile:rtfPath];
    }
    else{
        [_textV setString:@""];
    }
    
    
    if(videoPath){
        NSURL *url = [NSURL fileURLWithPath:videoPath];
        if(url){
            AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
            if(item){
                self.videoView.player = [AVPlayer playerWithPlayerItem:item];
            }
        }
    }
}


@end
