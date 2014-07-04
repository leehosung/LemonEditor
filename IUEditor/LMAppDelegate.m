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
#import "LMPreferenceWC.h"
#import "IUProjectController.h"
#import "LMNotiManager.h"
#import "JDEnvUtil.h"
#import "LMTutorialWC.h"
#import "LMHelpWC.h"

@implementation LMAppDelegate{
    LMStartWC *startWC;
    LMPreferenceWC *preferenceWC;
    LMNotiManager *notiManager;
    LMTutorialWC *tutorialWC;
}

+ (void)initialize{
    //user default setting
    NSString *defaultsFilename = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
    // initialize a dictionary with contents of it
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:defaultsFilename];
    // register the stuff
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [JDLogUtil showLogLevel:YES andFileName:YES andFunctionName:YES andLineNumber:YES];
    [JDLogUtil setGlobalLevel:JDLog_Level_Debug];
    [JDLogUtil enableLogSection:IULogSource];
    [JDLogUtil enableLogSection:IULogJS];
    [JDLogUtil enableLogSection:IULogAction];
//    [JDLogUtil enableLogSection:IULogText];
    

    
    
#if DEBUG
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
#else
    [self showStartWC:self];
    
    notiManager = [[LMNotiManager alloc] init];
    [notiManager connectWithServerAfterDelay:0];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"iututorial"] == NO) {
        tutorialWC = [[LMTutorialWC alloc] initWithWindowNibName:@"LMTutorialWC"];
        [tutorialWC showWindow:self];
    }
    
    
#endif
  

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
    
    NSArray *recents = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
    if ([recents count]){
        [self loadDocument:[[recents objectAtIndex:0] path]];
    }
    else {
        [self newDocument:self];
    }
#endif
    
}


- (IBAction)showStartWC:(id)sender{
    startWC = [LMStartWC sharedStartWindow];
    [startWC showWindow:self];
}


- (IBAction)openPreference:(id)sender {
     preferenceWC = [[LMPreferenceWC alloc] initWithWindowNibName:@"LMPreferenceWC"];
    [preferenceWC showWindow:self];
}

#pragma mark - application delegate

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender{
    return NO;
}


- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    if(flag == NO) {
#if DEBUG
        
        //open last document
        NSArray *recents = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
        if ([recents count]){
            NSURL *lastURL = [recents objectAtIndex:0];
            [(IUProjectController *)[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:lastURL display:YES completionHandler:nil];
            
            
        }
#else
        //cmd + N 화면
        //https://developer.apple.com/library/mac/documentation/cocoa/reference/NSApplicationDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/NSApplicationDelegate/applicationOpenUntitledFile:
        
        [self showStartWC:self];
        
#endif
        return NO;
    }
    return YES;
}

- (void)performHelpAboutProject:(id)sender{
    LMHelpWC *hWC = [LMHelpWC sharedHelpWC];
    [hWC showWindow:nil];
    [hWC setHelpWebURL:[NSURL URLWithString:@"http://jdlaborg.github.io/LemonEditor/"]];
    [hWC.window makeKeyAndOrderFront:self];
}

@end