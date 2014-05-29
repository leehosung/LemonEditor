//
//  LMStartNewDefaultVC.m
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartNewDefaultVC.h"
#import "JDFileUtil.h"
#import "IUProject.h"
#import "LMAppDelegate.h"
#import "LMWC.h"

@interface LMStartNewDefaultVC ()
@property (weak) IBOutlet NSTextField *defaultNewAppName;

@end

@implementation LMStartNewDefaultVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
     //   [_prevB setAction:@selector(pressPrevB)];
        [_nextB setAction:@selector(pressNextB)];
    }
    return self;
}


- (void)pressNextB{
    
    NSError *error;
    
    NSString *appName;
    appName = [_defaultNewAppName stringValue];
    NSString *appDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"select directory for project"] path];
    if(appDir == nil || [appName stringByTrim].length == 0){ //cancel
        return;
    }
    //git, heroku는 막아놓음
    NSDictionary *options = @{   IUProjectKeyGit: @(NO),
                                 IUProjectKeyAppName: appName,
                                 IUProjectKeyHeroku: @(NO),
                                 IUProjectKeyDirectory: appDir};
    
    IUProject *project = [[IUProject alloc] initWithCreation:options error:&error];
    
    if (error != nil) {
        assert(0);
    }
    
    LMWC *wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [wc showWindow:self];
    [wc loadProject:project.path];
    
    [self.view.window close];
    
}



@end
