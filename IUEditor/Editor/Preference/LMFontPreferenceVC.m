//
//  LMFontPreferenceVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 28..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMFontPreferenceVC.h"
#import "LMFontController.h"

@interface LMFontPreferenceVC ()

@property LMFontController *fontController;
@property (strong) IBOutlet NSDictionaryController *fontListDC;

@end

@implementation LMFontPreferenceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    _fontController = [LMFontController sharedFontController];
    [_fontListDC bind:NSContentDictionaryBinding toObject:_fontController withKeyPath:@"fontDict" options:nil];
}


@end
