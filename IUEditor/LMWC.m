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
#import "IUDocumentController.h"
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
    [self bind:@"selectedDocument" toObject:fileNaviVC withKeyPath:@"selection" options:nil];
    [_leftV addSubview:fileNaviVC.view];
    
    stackVC = [[LMStackVC alloc] initWithNibName:@"LMStackVC" bundle:nil];
    [_rightV addSubviewFullFrame:stackVC.view];

    canvasV = [[LMCanvasV alloc] init];
    [_centerV addSubviewFullFrame:canvasV];
    
    [self startNewProject];
}

-(void)loadProject:(NSString*)path{
    IUProject *project = [IUProject projectWithContentsOfPackage:path];
    fileNaviVC.project = project;
}

-(void)setSelectedDocument:(id)selectedDocument{
    _selectedDocument = selectedDocument;
    if ([selectedDocument isKindOfClass:[IUDocument class]]) {
        [stackVC setDocument:selectedDocument];
        [canvasV setDocument:selectedDocument];
    }
    else if ([selectedDocument isKindOfClass:[IUProject class]]){
        return;
    }
    else if ([selectedDocument isKindOfClass:[IUDocumentGroup class]]){
        return;
    }
    else {
        assert(0);
    }
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
