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
#import "LMWidgetLibraryVC.h"

#import "IUDocumentController.h"
#import "IUProject.h"

@interface LMWC ()


@property (weak) IBOutlet NSView *leftTopV;
@property (weak) IBOutlet NSView *leftBottomV;

@property (weak) IBOutlet NSView *centerV;
@property (weak) IBOutlet NSView *toolbarV;
@property (weak) IBOutlet NSView *rightV;
@property (weak) IBOutlet NSView *bottomV;

@end

@implementation LMWC{
    LMFileNaviVC    *fileNaviVC;
    LMStackVC       *stackVC;
    LMCanvasV       *canvasV;
    LMWidgetLibraryVC   *widgetLibraryVC;
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
    fileNaviVC = [[LMFileNaviVC alloc] initWithNibName:@"LMFileNaviVC" bundle:nil];
    [self bind:@"selectedDocument" toObject:fileNaviVC withKeyPath:@"selection" options:nil];
    [_leftBottomV addSubview:fileNaviVC.view];
    
    stackVC = [[LMStackVC alloc] initWithNibName:@"LMStackVC" bundle:nil];
    [_rightV addSubviewFullFrame:stackVC.view];

    canvasV = [[LMCanvasV alloc] init];
    [_centerV addSubviewFullFrame:canvasV];
    
    widgetLibraryVC = [[LMWidgetLibraryVC alloc] initWithNibName:@"LMWidgetLibraryVC" bundle:nil];
    [_leftTopV addSubview:widgetLibraryVC.view];
    
    [self startNewProject];
}

-(void)loadProject:(NSString*)path{
    IUProject *project = [IUProject projectWithContentsOfPackage:path];
    fileNaviVC.project = project;
    canvasV.resourcePath = project.path;

    NSString *widgetFilePath = [[NSBundle mainBundle] pathForResource:@"widgetForDefault" ofType:@"plist"];
    NSArray *availableWidgetProperties = [NSArray arrayWithContentsOfFile:widgetFilePath];
    [widgetLibraryVC setWidgetProperties:availableWidgetProperties];
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

-(void)startNewProject{
    NSError *error;

    NSDictionary *dict = @{IUProjectKeyAppName: @"myApp",
                           IUProjectKeyGit: @(NO),
                           IUProjectKeyHeroku: @(NO),
                           IUProjectKeyDirectory: [@"~/IUProjTemp" stringByExpandingTildeInPath]};
    [IUProject createProject:dict error:&error];
    NSString *projectPath = [IUProject createProject:dict error:&error];
    if (error != nil) {
        assert(0);
    }
    [self loadProject:projectPath];
}

@end