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


-(void)appDirPathDidChange{
    self.imgDirPath = [self.appDirPath stringByAppendingString:@"static"];
    self.templateDirPath = [self.appDirPath stringByAppendingString:@"templates"];
}

- (void)performNext{
    NSDictionary *options = @{   IUProjectKeyGit: @(NO),
                                 IUProjectKeyHeroku: @(NO),
                                 IUProjectKeyType:@(IUProjectTypeDjango),
                                 };
    
    [(IUProjectController *)[NSDocumentController sharedDocumentController] newDocument:self withOption:options];
}

- (void)performPrev{
    assert(_parentVC);
    [_parentVC show];
}

- (IBAction)performProjectDirSelect:(id)sender {
    self.djangoProjectDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Django Project Directory"] path];
    self.djangoResourceDir = [self.djangoProjectDir stringByAppendingPathComponent:@"templates/resources"];
    self.djangoTemplateDir = [self.djangoProjectDir stringByAppendingPathComponent:@"templates"];
}

- (IBAction)performResourceDirSelect:(id)sender {
    self.djangoProjectDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Django Resource Directory"] path];
}

- (IBAction)performTemplateDirSelect:(id)sender {
    self.djangoTemplateDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Django Project Template Directory"] path];
}

- (void)show{
    assert(_nextB);
    assert(_prevB);
    
    _nextB.target = self;
    _prevB.target = self;
    
    [_prevB setEnabled:YES];
    [_nextB setAction:@selector(performNext)];
    [_prevB setAction:@selector(performPrev)];
}

@end
