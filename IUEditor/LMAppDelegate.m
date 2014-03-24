//
//  LMAppDelegate.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMAppDelegate.h"
#import "LMWC.h"
@implementation LMAppDelegate{
    LMWC *wc;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [wc showWindow:self];
}

@end
