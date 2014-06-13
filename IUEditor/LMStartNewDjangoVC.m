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
    
    NSDictionary *options = @{   IUProjectKeyGit: @(NO),
                                 IUProjectKeyHeroku: @(NO),
                                 IUProjectKeyType:@(IUProjectTypeDjango),
                                 };
    
    [(IUProjectController *)[NSDocumentController sharedDocumentController] newDocument:self withOption:options];
}


@end
