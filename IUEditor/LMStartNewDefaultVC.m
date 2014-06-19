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
#import "IUProjectController.h"

@interface LMStartNewDefaultVC ()
@property (weak) IBOutlet NSTextField *defaultNewAppName;

@end

@implementation LMStartNewDefaultVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [_nextB setAction:@selector(pressNextB)];
    }
    return self;
}


- (void)pressNextB{
    [self.view.window close];
    
    NSDictionary *options = @{  IUProjectKeyGit: @(NO),
                                IUProjectKeyHeroku: @(NO),
                                IUProjectKeyType:@(IUProjectTypeDefault),
                                };
    
    [(IUProjectController *)[NSDocumentController sharedDocumentController] newDocument:self withOption:options];
}

@end
