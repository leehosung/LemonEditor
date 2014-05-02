//
//  LMStartNewDefaultVC.m
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartNewDefaultVC.h"
#import "JDFileUtil.h"
#import "IUProject.h"
#import "LMAppDelegate.h"

@interface LMStartNewDefaultVC ()

@end

@implementation LMStartNewDefaultVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)show{
    assert(_nextB);
    [_nextB setTarget:self];
    [_nextB setAction:@selector(pressNextB)];
}

- (void)pressNextB{

    NSDictionary *dictionary = @{IUProjectKeyGit: @(NO),
                                 IUProjectKeyAppName: @"ASDFQWER",
                                 IUProjectKeyHeroku: @(NO),
                                 IUProjectKeyDirectory: @"/Users/jd/asdf"};
    NSString *path = [IUProject createProject:dictionary error:nil];
    LMAppDelegate *appDelegate = [NSApp delegate];
    [appDelegate loadDocument:path];
    [self.view.window close];
}
@end
