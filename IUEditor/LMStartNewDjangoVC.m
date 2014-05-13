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

@interface LMStartNewDjangoVC ()

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
- (void)show{
    assert(_nextB);
    [_nextB setTarget:self];
    [_nextB setAction:@selector(pressNextB)];
}


-(void)appDirPathDidChange{
    self.imgDirPath = [self.appDirPath stringByAppendingString:@"static"];
    self.templateDirPath = [self.appDirPath stringByAppendingString:@"templates"];
}

- (void)pressNextB{
    
    NSDictionary *dictionary = @{IUProjectKeyGit: @(NO),
                                 IUProjectKeyAppName: @"gallery",
                                 IUProjectKeyHeroku: @(NO),
                                 IUProjectKeyDirectory: [@"~/IUProjTemp" stringByExpandingTildeInPath]};
    IUProject *project = [IUDjangoProject createProject:dictionary error:nil];
    LMAppDelegate *appDelegate = [NSApp delegate];
    [appDelegate loadDocument:project.path];
    [self.view.window close];
}


@end
