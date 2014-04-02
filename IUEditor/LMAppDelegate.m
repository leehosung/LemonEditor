//
//  LMAppDelegate.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMAppDelegate.h"
#import "LMWC.h"
#import "JDLogUtil.h"


@implementation LMAppDelegate{
    LMWC *wc;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [JDLogUtil enableLogSection:IULogSource];
    
    wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [wc showWindow:self];
    
    [wc addFrame:400];
#pragma mark -
#pragma mark canvas test
#if 0
    self.testController = [[TestController alloc] initWithWindowNibName:@"TestController"];
    self.testController.mainWC = self.canvasWC;
    [self.testController showWindow:nil];
    [wc addSelectedIU:@"test"];
    
#endif
}

@end
