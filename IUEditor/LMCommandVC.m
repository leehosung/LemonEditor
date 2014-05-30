//
//  LMCommandVC.m
//  IUEditor
//
//  Created by jd on 5/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMCommandVC.h"
#import "IUDocumentNode.h"

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
    IUCompiler *compiler = _docController.project.compiler;
    if (compiler.rule == IUCompileRuleDefault) {
        IUProject *project = _docController.project;
        BOOL result = [project build:nil];
        if (result == NO) {
            assert(0);
        }
        IUDocumentNode *node = [[_docController selectedObjects] firstObject];
        NSString *firstPath = [project.directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.html",project.buildDirectoryName, [node.name lowercaseString]] ];
        [[NSWorkspace sharedWorkspace] openFile:firstPath];
    }
    else if (compiler.rule == IUCompileRuleDjango){
        if (runningState == 0) {
            [self runOrStopServer:self];
        }
        IUProject *project = _docController.project;
        BOOL result = [project build:nil];
        if (result == NO) {
            assert(0);
        }
        IUDocumentNode *node = [[_docController selectedObjects] firstObject];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://127.0.0.1:8000/%@", [node.name lowercaseString]]];
        [[NSWorkspace sharedWorkspace] openURL:url];
    }
}

- (IBAction) runOrStopServer:(id)sender{
    //TODO: 제대로 동작안함
#if 0
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
        [serverTask setCurrentDirectoryPath:[_docController.project.directory stringByDeletingLastPathComponent]];
        [serverTask setArguments:@[@"manage.py", @"runserver", @"8000"]];
        
        [serverTask launch];
        [_serverB setTitle:@">"];
    }
    else {
        // run server
        if ([serverTask isRunning]) {
            [serverTask terminate];
            [serverTask waitUntilExit];
        }
        runningState = 0;
        [_serverB setTitle:@"||"];
    }
#endif
}

- (IBAction)changeCompilerRule:(id)sender {
    _docController.project.compileRule = [_compilerB indexOfSelectedItem];
}

- (IBAction)sync:(id)sender {
    
}

@end
