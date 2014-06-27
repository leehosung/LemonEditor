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

@interface LMCommandVC ()
@property (weak) IBOutlet NSButton *buildB;
@property (weak) IBOutlet NSButton *serverB;
@property (weak) IBOutlet NSPopUpButton *compilerB;
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
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://127.0.0.1:8000/%@", [node.name lowercaseString]]];
        [[NSWorkspace sharedWorkspace] openURL:url];
    }
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

@end
