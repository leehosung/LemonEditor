//
//  LMHelpTextPopoverVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMHelpTextPopoverVC.h"

@interface LMHelpTextPopoverVC ()

@property (weak) IBOutlet NSTextField *titleTF;
@property (unsafe_unretained) IBOutlet NSTextView *contentTextV;

@end

@implementation LMHelpTextPopoverVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self loadView];
    }
    return self;
}

- (void)setTitle:(NSString *)title rtfPath:(NSString *)rtfPath{
    [_titleTF setStringValue:title];
    if(rtfPath){
        [_contentTextV readRTFDFromFile:rtfPath];
    }
    else{
        [_contentTextV setString:@""];
    }
}

- (void)setTitle:(NSString *)title string:(NSString *)string{
    [_titleTF setStringValue:title];
    if(string){
        [_contentTextV setString:string];
    }
}
@end
