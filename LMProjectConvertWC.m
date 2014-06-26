//
//  LMProjectConvertWC.m
//  IUEditor
//
//  Created by jd on 5/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMProjectConvertWC.h"
#import "IUDjangoProject.h"
#import "IUProjectController.h"

@interface LMProjectConvertWC ()
@property (weak) IBOutlet NSView *htmlTabV;
@property (weak) IBOutlet NSView *djangoTabV;

@property (weak) IBOutlet NSView *htmlConvertV;
@property (weak) IBOutlet NSView *htmlRemainV;

@property (weak) IBOutlet NSView *djangoConvertV;
@property (weak) IBOutlet NSView *djangoRemainV;

@property (nonatomic) NSString *targetProjectDirectory;
@property NSString *buildProjectDirectory;
@property NSString *resourceProjectDirectory;

@end

@implementation LMProjectConvertWC{
    NSString *outputFilePath;
    IUProject *_project;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)setCurrentProject:(IUProject *)currentProject{
    _project = currentProject;
    //load nib
    [self window];
    [self setTargetProjectDirectory:@"/Users/jd/Desktop"];
    if ([[currentProject className] isEqualToString:@"IUProject"]) {
        [_djangoTabV addSubview:_djangoConvertV];
        [_htmlTabV addSubview:_htmlRemainV];
    }
    else {
        [_htmlTabV addSubview:_htmlConvertV];
        [_djangoTabV addSubview:_htmlRemainV];
    }
}

- (IBAction)convertDjango:(id)sender{
    if (_targetProjectDirectory == nil || _buildProjectDirectory == nil || _resourceProjectDirectory == nil) {
        [JDLogUtil alert:@"Please fill all fields"];
        return;
    }
    
    NSString *projectPath = [_targetProjectDirectory stringByAppendingFormat:@"/%@.iu", [_targetProjectDirectory lastPathComponent]];
    NSDictionary *options = @{   IUProjectKeyGit: @(NO),
                                 IUProjectKeyHeroku: @(NO),
                                 IUProjectKeyAppName : [_targetProjectDirectory lastPathComponent],
                                 IUProjectKeyProjectPath : projectPath,
                                 IUProjectKeyType:@(IUProjectTypeDjango),
                                 IUProjectKeyResourcePath : _resourceProjectDirectory,
                                 IUProjectKeyBuildPath : _buildProjectDirectory,
                                 IUProjectKeyConversion :
                                     _project
                                 };
    
    [(IUProjectController *)[NSDocumentController sharedDocumentController] newDocument:self withOption:options];
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}
- (IBAction)pressSelectProjectDirectory:(id)sender {
    NSURL *url = [[JDFileUtil util] openDirectoryByNSOpenPanel];
    self.targetProjectDirectory = [url path];
}

- (void)setTargetProjectDirectory:(NSString *)targetProjectDirectory{
    _targetProjectDirectory = targetProjectDirectory;
    self.buildProjectDirectory = [_targetProjectDirectory stringByAppendingPathComponent:@"templates"];
    self.resourceProjectDirectory = [_targetProjectDirectory stringByAppendingPathComponent:@"templates/resource"];
}

- (IBAction)pressCancelB:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseAbort];
}

- (NSString *)outputFilePath{
    return outputFilePath;
}


@end
