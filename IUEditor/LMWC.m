//
//  LMWC.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMWC.h"
#import "LMFileNaviVC.h"
#import "LMStackVC.h"
#import "LMCanvasV.h"

#import "IUProject.h"

@interface LMWC ()

@end

@implementation LMWC{
    LMFileNaviVC    *fileNaviVC;
    LMStackVC       *stackVC;
    LMCanvasV       *canvasV;
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
    //setting window view
    
    fileNaviVC = [[LMFileNaviVC alloc] initWithNibName:@"LMFileNaviVC" bundle:nil];
    [self bind:@"currentDocument" toObject:fileNaviVC withKeyPath:@"currentDocument" options:nil];
    [_leftV addSubview:fileNaviVC.view];
    
    stackVC = [[LMStackVC alloc] initWithNibName:@"LMStackVC" bundle:nil];
    [_rightV addSubview:stackVC.view];

    canvasV = [[LMCanvasV alloc] init];
    [canvasV bind:@"document" toObject:self withKeyPath:@"currentDocument" options:nil];
    [_canvasV addSubviewFullFrame:canvasV];
    
    [self startNewProject];
}

-(void)loadProject:(NSString*)path{
    IUProject *project = [IUProject projectWithContentsOfPackage:path];
    fileNaviVC.project = project;
}

//FIXME: resourcePath
-(void)startNewProject{
    NSError *error;

    NSDictionary *dict = @{IUProjectKeyAppName: @"myApp",
                           IUProjectKeyGit: @(NO),
                           IUProjectKeyHeroku: @(NO),
                           IUProjectKeyDirectory: [@"~/IUProjTemp" stringByExpandingTildeInPath]};
    
    IUProject *project = [[IUProject alloc] init:dict error:&error];
    canvasV.resourcePath = project.path;
    fileNaviVC.project = project;
}

@end
