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
    if (_docController.project.runnable == NO) {
        [_serverB setEnabled:NO];
        [[_compilerB itemAtIndex:1] setEnabled:NO];
        [_compilerB setAutoenablesItems:NO];
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
        NSString *firstPath = [project.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.html",project.buildDirectoryName, [node.name lowercaseString]] ];
        [[NSWorkspace sharedWorkspace] openFile:firstPath];
    }
    else if (compiler.rule == IUCompileRuleDjango){
        IUProject *project = _docController.project;
        BOOL result = [project build:nil];
        if (result == NO) {
            assert(0);
        }
        IUDocumentNode *node = [[_docController selectedObjects] firstObject];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://127.0.0.1/%@", [node.name lowercaseString]]];
        [[NSWorkspace sharedWorkspace] openURL:url];
    }
}

- (IBAction) runOrStopServer:(id)sender{
    if (runningState == 0) {
        // stop server
        serverTask = [[NSTask alloc] init];
        NSPipe *stdOutput = [NSPipe pipe];
        NSPipe *stdError = [NSPipe pipe];
        
        NSFileHandle *stdOutputHandle = [stdOutput fileHandleForReading];
        NSFileHandle *stdErrorHandle = [stdError fileHandleForReading];

        [serverTask setStandardOutput:stdOutputHandle];
        [serverTask setStandardError:stdErrorHandle];
        runningState = 1;
        [_serverB setTitle:@">"];
    }
    else {
        // run server
        if ([serverTask isRunning]) {
            [serverTask interrupt];
        }
        runningState = 0;
        [_serverB setTitle:@"||"];
    }
}

- (IBAction)changeCompilerRule:(id)sender {
    
}

- (IBAction)sync:(id)sender {
    
}

@end
