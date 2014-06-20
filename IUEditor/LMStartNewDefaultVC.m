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
#import "LMStartNewVC.h"

@interface LMStartNewDefaultVC ()
@end

@implementation LMStartNewDefaultVC

- (void)performNext{
    [self.view.window close];
    
    NSDictionary *options = @{  IUProjectKeyGit: @(NO),
                                IUProjectKeyHeroku: @(NO),
                                IUProjectKeyType:@(IUProjectTypeDefault),
                                };
    
    [(IUProjectController *)[NSDocumentController sharedDocumentController] newDocument:self withOption:options];
}

- (void)performPrev{
    assert(_parentVC);
    [_parentVC show];
}

- (void)show{
    assert(_parentVC);
    assert(_nextB);
    assert(_prevB);
    assert(_nextB != _prevB);
    
    [_nextB setEnabled:YES];
    [_prevB setEnabled:YES];
    
    _prevB.target = self;
    _nextB.target = self;
    [_prevB setAction:@selector(performPrev)];
    [_nextB setAction:@selector(performNext)];
}

@end
