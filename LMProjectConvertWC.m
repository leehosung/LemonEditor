//
//  LMProjectConvertWC.m
//  IUEditor
//
//  Created by jd on 5/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMProjectConvertWC.h"
#import "IUDjangoProject.h"


@interface LMProjectConvertWC ()

@end

@implementation LMProjectConvertWC{
    NSString *outputFilePath;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)convertDjango:(id)sender{
    NSDictionary *setting = @{IUProjectKeyDirectory: _targetProjectDirectory};
    NSError *err;
    assert(_currentProject);
    IUDjangoProject *newProject = [IUDjangoProject convertProject:_currentProject setting:setting error:&err];
    if (newProject) {
        outputFilePath = newProject.path;
        [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    }
    else {
        assert(0);
    }
}
- (IBAction)pressSelectProjectDirectory:(id)sender {
    NSURL *url = [[JDFileUtil util] openDirectoryByNSOpenPanel];
    self.targetProjectDirectory = [url path];
}

- (IBAction)pressCancelB:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseAbort];
}

- (NSString *)outputFilePath{
    return outputFilePath;
}


@end
