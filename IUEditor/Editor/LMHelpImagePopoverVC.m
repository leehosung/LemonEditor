//
//  LMHelpPopoverVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMHelpImagePopoverVC.h"

@interface LMHelpImagePopoverVC ()

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *titleTF;
@property (weak) IBOutlet NSTextField *subtitleTF;
@property (unsafe_unretained) IBOutlet NSTextView *contentTextV;

@end

@implementation LMHelpImagePopoverVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self loadView];
    }
    return self;
}

- (void)setImage:(NSImage *)image title:(NSString *)title subTitle:(NSString *)subTitle rtfPath:(NSString *)rtfPath{
    if(image){
        [_imageView setImage:image];
    }
    [_titleTF setStringValue:title];
    [_subtitleTF setStringValue:subTitle];
    if(rtfPath){
        [_contentTextV readRTFDFromFile:rtfPath];
    }
    else{
        [_contentTextV setString:@""];
    }
}

- (void)setImage:(NSImage *)image title:(NSString *)title subTitle:(NSString *)subTitle text:(NSString *)text{
    if(image){
        [_imageView setImage:image];
    }
    [_titleTF setStringValue:title];
    [_subtitleTF setStringValue:subTitle];
    [_contentTextV setString:text];
}

@end
