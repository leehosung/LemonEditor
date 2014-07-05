//
//  LMCommandVC.m
//  IUEditor
//
//  Created by jd on 5/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMCommandVC.h"
#import "IUSheetGroup.h"
#import "IUDjangoProject.h"
#import "JDScreenRecorder.h"
#import "JDDateTimeUtil.h"
#import "LMTutorialManager.h"
#import "LMHelpWC.h"

@interface LMCommandVC ()
@property (weak) IBOutlet NSButton *buildB;
@property (weak) IBOutlet NSButton *serverB;
@property (weak) IBOutlet NSPopUpButton *compilerB;
@property (weak) IBOutlet NSButton *recordingB;
@end

@implementation LMCommandVC {
    BOOL runningState;
    NSTask *serverTask;
    __weak NSButton *_buildB;
    __weak NSButton *_serverB;
    __weak NSPopUpButton *_compilerB;
    
    
    NSPipe *stdOutput;
    NSPipe *stdError;
    
    NSFileHandle *stdOutputHandle;
    NSFileHandle *stdErrorHandle;

    JDScreenRecorder *screenRecorder;
    BOOL recording;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib{
    [_compilerB bind:NSSelectedIndexBinding toObject:self withKeyPath:@"docController.project.compiler.rule" options:nil];
    [self addObserver:self forKeyPath:@"docController.project.runnable" options:NSKeyValueObservingOptionInitial context:nil];
}

-(void)dealloc{
    //release 시점 확인용
    assert(0);
    
    //[self removeObserver:self forKeyPath:@"docController.project.runnable"];
}

-(void)docController_project_runnableDidChange:(NSDictionary*)change{
    if (_docController.project.runnable == NO) {
        [_serverB setEnabled:NO];
        [[_compilerB itemAtIndex:1] setEnabled:NO];
        [_compilerB setAutoenablesItems:NO];
    }
    else {
        [_serverB setEnabled:YES];
        [[_compilerB itemAtIndex:1] setEnabled:YES];
        [_compilerB setAutoenablesItems:YES];
    }
}

- (IBAction)build:(id)sender {
    
    IUCompileRule rule = _docController.project.compiler.rule;
    if (rule == IUCompileRuleDefault) {
        IUProject *project = _docController.project;
        BOOL result = [project build:nil];
        if (result == NO) {
            assert(0);
        }
        IUSheet *doc = [[_docController selectedObjects] firstObject];
        NSString *firstPath = [project.directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.html",project.buildPath, [doc.name lowercaseString]] ];
        [[NSWorkspace sharedWorkspace] openFile:firstPath];
    }
    else if (rule == IUCompileRuleDjango){
        if (runningState == 0) {
            [self runOrStopServer:self];
        }
        IUProject *project = _docController.project;
        BOOL result = [project build:nil];
        if (result == NO) {
            assert(0);
        }
        IUSheet *node = [[_docController selectedObjects] firstObject];
        
        //project or IUGroup
        if([node isKindOfClass:[IUSheet class]] == NO){
            node = [project.pageDocuments firstObject];
        }
        
        BOOL runningLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"DjangoDebugLoopback"];
        if (runningLocal) {
            NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:@"DjangoDebugPort"];
            if (port == nil) {
                port = @"8000";
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://127.0.0.1:%@/%@",port, [node.name lowercaseString]]];
            [[NSWorkspace sharedWorkspace] openURL:url];
        }
        else {
            NSString *firstPath = [project.directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.html",project.buildPath, [node.name lowercaseString]] ];
            [[NSWorkspace sharedWorkspace] openFile:firstPath];
        }
    }
    
    //show tutorial if needed
    //    if ([LMTutorialManager shouldShowTutorial:@"run"]) {
    [[LMHelpWC sharedHelpWC] showHelpDocumentWithKey:@"RunningAProject"];
    //    }
    

}

- (IBAction) runOrStopServer:(id)sender{
    //FIXME: 제대로 동작안함
    /*
    if (runningState == 0) {
        // stop server
        serverTask = [[NSTask alloc] init];
        stdOutput = [NSPipe pipe];
        stdError = [NSPipe pipe];
        
        stdOutputHandle = [stdOutput fileHandleForReading];
        stdErrorHandle = [stdError fileHandleForReading];

        [serverTask setStandardOutput:stdOutputHandle];
        [serverTask setStandardError:stdErrorHandle];
        runningState = 1;
        
        
        [serverTask setLaunchPath:@"/usr/bin/python"];
        [serverTask setCurrentDirectoryPath:_docController.project.directoryPath];
        [serverTask setArguments:@[@"manage.py", @"runserver", @"8000"]];
        
        [serverTask launch];
    }
    else {
        // run server
        if ([serverTask isRunning]) {
            [serverTask terminate];
            [serverTask waitUntilExit];
        }
        runningState = 0;
    }
     */
}

- (IBAction)changeCompilerRule:(id)sender {
    _docController.project.compiler.rule = (int)[_compilerB indexOfSelectedItem];
}

- (IBAction)sync:(id)sender {
    
}

- (IBAction)toggleRecording:(id)sender{
    if (recording == NO) {
        recording = YES;
        [_recordingB setImage:[NSImage imageNamed:@"record_stop"]];
        [JDUIUtil hudAlert:@"Recording Start" second:3];
        screenRecorder = [[JDScreenRecorder alloc] init];
        
        NSString *fileName = [NSString stringWithFormat:@"%@/Desktop/%@.mp4", NSHomeDirectory(), [JDDateTimeUtil stringForDate:[NSDate date] option:JDDateStringTimestampType2]];
        [screenRecorder startRecord:[NSURL fileURLWithPath:fileName]];
    }
    else {
        recording = NO;
        [_recordingB setImage:[NSImage imageNamed:@"record"]];
        [screenRecorder finishRecord];
        [JDUIUtil hudAlert:@"Recording saved at Desktop" second:3];
    }
}


@end
