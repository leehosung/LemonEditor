//
//  LMStartNewDjangoVC.m
//  IUEditor
//
//  Created by jw on 5/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartNewDjangoVC.h"
#import "JDFileUtil.h"
#import "IUDjangoProject.h"
#import "LMAppDelegate.h"
#import "IUProjectController.h"
#import "LMStartNewVC.h"

@interface LMStartNewDjangoVC ()
@property NSString *djangoProjectDir;
@property NSString *djangoResourceDir;
@property NSString *djangoTemplateDir;
@end

@implementation LMStartNewDjangoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)performNext{
    if ([_djangoProjectDir length] == 0 ) {
        [JDLogUtil alert:@"Input project directory path"];
        return;
    }
    if ([_djangoResourceDir length] == 0 ) {
        [JDLogUtil alert:@"Input project resource directory path"];
        return;
    }
    if ([_djangoTemplateDir length] == 0 ) {
        [JDLogUtil alert:@"Input project template directory path"];
        return;
    }

    NSString *fileName = [NSString stringWithFormat:@"%@.iu", [_djangoProjectDir lastPathComponent]];
    NSDictionary *options = @{   IUProjectKeyGit: @(NO),
                                 IUProjectKeyHeroku: @(NO),
                                 IUProjectKeyAppName : [_djangoProjectDir lastPathComponent],
                                 IUProjectKeyProjectPath : [_djangoProjectDir stringByAppendingPathComponent:fileName],
                                 IUProjectKeyType:@(IUProjectTypeDjango),
                                 IUProjectKeyResourcePath : _djangoResourceDir,
                                 IUProjectKeyBuildPath : _djangoTemplateDir
                                 };
    
    [(IUProjectController *)[NSDocumentController sharedDocumentController] newDocument:self withOption:options];
    [self.view.window close];
}

- (void)performPrev{
    NSAssert(_parentVC, @"");
    [_parentVC show];
}

- (IBAction)performProjectDirSelect:(id)sender {
    self.djangoProjectDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Django Project Directory"] path];
    self.djangoResourceDir = [self.djangoProjectDir stringByAppendingPathComponent:@"templates/resource"];
    self.djangoTemplateDir = [self.djangoProjectDir stringByAppendingPathComponent:@"templates"];
}

- (IBAction)performResourceDirSelect:(id)sender {
    self.djangoProjectDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Django resource Directory"] path];
}

- (IBAction)performTemplateDirSelect:(id)sender {
    self.djangoTemplateDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Django Project Template Directory"] path];
}

- (void)show{
    NSAssert(_nextB, @"");
    NSAssert(_prevB, @"");
    
    _nextB.target = self;
    _prevB.target = self;
    
    [_prevB setEnabled:YES];
    [_nextB setAction:@selector(performNext)];
    [_prevB setAction:@selector(performPrev)];
}

@end
