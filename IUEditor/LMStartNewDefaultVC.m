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
    }
    return self;
}

- (void)show{
    assert(_nextB);
    [_nextB setTarget:self];
    [_nextB setAction:@selector(pressNextB)];
}

- (void)pressNextB{
    
    NSError *error;
    
    NSString *appName;
    appName = [_defaultNewAppName stringValue];
    NSString *appDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"select directory for project"] path];
    if(appDir == nil){ //cancel
        return;
    }
    //git, heroku는 막아놓음
    NSDictionary *dictionary = @{IUProjectKeyGit: @(NO),
                                 IUProjectKeyAppName: appName,
                                 IUProjectKeyHeroku: @(NO),
                                 IUProjectKeyDirectory: appDir};
    
    NSString *path = [IUProject createProject:dictionary error:&error];
    
    if (error != nil) {
        assert(0);
    }
    
    LMWC *wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [wc showWindow:self];
    [wc loadProject:path];
    [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"lastDocument"];
    
    [self.view.window close];
    
}
@end
