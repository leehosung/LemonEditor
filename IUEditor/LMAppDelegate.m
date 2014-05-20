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
#import "LMStartWC.h"
#import "IUDjangoProject.h"

@implementation LMAppDelegate{
    LMStartWC *startWC;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSZeroRange = NSMakeRange(0, 0);
    [JDLogUtil showLogLevel:YES andFileName:YES andFunctionName:YES andLineNumber:YES];
    [JDLogUtil setGlobalLevel:JDLog_Level_Debug];
    [JDLogUtil enableLogSection:IULogSource];
    [JDLogUtil enableLogSection:IULogJS];
    [JDLogUtil enableLogSection:IULogAction];
//    [JDLogUtil enableLogSection:IULogText];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];


#pragma mark -
#pragma mark canvas test
#if 0
    JDFatalLog(@"fatal");
    JDErrorLog(@"error");
    JDWarnLog(@"warn");
    JDInfoLog(@"info");
    JDDebugLog(@"debug");
    JDTraceLog(@"trace");
    
    self.testController = [[TestController alloc] initWithWindowNibName:@"TestController"];
    self.testController.mainWC = self.canvasWC;
    [self.testController showWindow:nil];
    [wc addSelectedIU:@"test"];
#endif
    
    //요 부분을 고쳐서 처음 런칭했을 때 화면을 바꾸자.
    [self openDocument:nil];
}

- (IBAction)showStartWC:(id)sender{
    for (NSWindow *window in [NSApp windows]){
        [window close];
    }
    startWC = [[LMStartWC alloc] initWithWindowNibName:@"LMStartWC"];
    [startWC showWindow:self];
}

- (void)openDocument:(id)sender{
    NSString *value;
    if ([sender isKindOfClass:[NSMenuItem class]]) {
        value = [[[JDFileUtil util] openFileByNSOpenPanel] path];
    }
    else {
        value = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastDocument"];
        if(value==nil){
            //open new document
            [self newDocument:self];
            //return;
        }
    }
    
    LMWC *wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [wc showWindow:self];
    [wc loadProject:value];
}

- (void)loadDocument:(NSString*)path{
    LMWC *wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [wc showWindow:self];
    [wc loadProject:path];
}

-(void)newDocument:(NSMenuItem*)sender{
    if ([sender isKindOfClass:[NSMenuItem class]]) {
        if (sender.tag == 1) {
            [self newDjangoDocument:sender];
            return;
        }
    }
    NSError *error;
    
    NSDictionary *dict = @{IUProjectKeyAppName: @"myApp",
                           IUProjectKeyGit: @(NO),
                           IUProjectKeyHeroku: @(NO),
                           IUProjectKeyDirectory: [@"~/IUProjTemp" stringByExpandingTildeInPath]};
    
    IUProject *newProject = [IUProject createProject:dict error:&error];
    if (error != nil) {
        assert(0);
    }
    LMWC *wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [wc showWindow:self];
    [wc loadProject:newProject.path];
}

-(void)newDjangoDocument:(id)sender{
    NSError *error;
    
    NSDictionary *dict = @{IUProjectKeyAppName: @"gallery",
                           IUProjectKeyGit: @(NO),
                           IUProjectKeyHeroku: @(NO),
                           IUProjectKeyDirectory: [@"~/IUProjTemp/gallery" stringByExpandingTildeInPath]};
    
    IUDjangoProject *project = [IUDjangoProject createProject:dict error:&error];
    if (error != nil) {
        assert(0);
    }
    LMWC *wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [wc showWindow:self];
    [wc loadProject:project.path];
}


@end