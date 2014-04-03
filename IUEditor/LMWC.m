//
//  LMWC.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMWC.h"

#import "LMWindow.h"

#import "LMFileNaviVC.h"
#import "LMStackVC.h"
#import "LMWidgetLibraryVC.h"
#import "LMCanvasVC.h"

#import "IUDocumentController.h"
#import "IUProject.h"
#import "IUDocumentNode.h"
#import "IUResourceGroupNode.h"
#import "IUResourceNode.h"
#import "LMResourceVC.h"
#import "LMToolbarVC.h"

@interface LMWC ()
@property (weak) IBOutlet NSView *leftTopV;
@property (weak) IBOutlet NSView *leftBottomV;

@property (weak) IBOutlet NSView *centerV;
@property (weak) IBOutlet NSView *toolbarV;
@property (weak) IBOutlet NSView *rightV;
@property (weak) IBOutlet NSView *bottomV;

@property (weak) IBOutlet NSView *resourceV;
@end

@implementation LMWC{
    LMFileNaviVC    *fileNaviVC;
    LMStackVC       *stackVC;
    LMCanvasVC *canvasVC;
    LMWidgetLibraryVC   *widgetLibraryVC;
    LMToolbarVC     *toolbarVC;
    LMResourceVC    *resourceVC;

    IUProject   *_project;

}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
   
    }
    return self;
}



- (void)windowDidLoad
{
    fileNaviVC = [[LMFileNaviVC alloc] initWithNibName:@"LMFileNaviVC" bundle:nil];
    [self bind:@"selectedNode" toObject:fileNaviVC withKeyPath:@"selection" options:nil];
    [_leftBottomV addSubview:fileNaviVC.view];
    
    stackVC = [[LMStackVC alloc] initWithNibName:@"LMStackVC" bundle:nil];
    [_rightV addSubviewFullFrame:stackVC.view];
    
    canvasVC = [[LMCanvasVC alloc] initWithNibName:@"LMCanvasVC" bundle:nil];
    [_centerV addSubviewFullFrame:canvasVC.view];
    ((LMWindow *)self.window).canvasView =  (LMCanvasView *)canvasVC.view;
    
    widgetLibraryVC = [[LMWidgetLibraryVC alloc] initWithNibName:@"LMWidgetLibraryVC" bundle:nil];
    [_leftTopV addSubview:widgetLibraryVC.view];
    
    toolbarVC = [[LMToolbarVC alloc] initWithNibName:@"LMToolbarVC" bundle:nil];
    [_toolbarV addSubview:toolbarVC.view];
    
    resourceVC = [[LMResourceVC alloc] initWithNibName:@"LMResourceVC" bundle:nil];
    [_resourceV addSubview:resourceVC.view];
    [self startNewProject];
}

-(void)loadProject:(NSString*)path{
    _project = [IUProject projectWithContentsOfPackage:path];

    fileNaviVC.project = _project;
    canvasVC.resourcePath = _project.path;
    [fileNaviVC selectFirstDocument];


    //construct widget library
    [widgetLibraryVC setProject:_project];
    NSString *widgetFilePath = [[NSBundle mainBundle] pathForResource:@"widgetForDefault" ofType:@"plist"];
    NSArray *availableWidgetProperties = [NSArray arrayWithContentsOfFile:widgetFilePath];
    [widgetLibraryVC setWidgetProperties:availableWidgetProperties];
    
    for (IUNode *node in _project.children) {
        if ([node isKindOfClass:[IUResourceGroupNode class]]) {
            [resourceVC setNode:(IUResourceGroupNode*)node];
            break;
        }
    }
}

-(void)setSelectedNode:(IUNode*)selectedNode{
    _selectedNode = selectedNode;
    if ([selectedNode isKindOfClass:[IUDocumentNode class]]) {
        IUDocument *document = ((IUDocumentNode*)selectedNode).document;
        [stackVC setDocument:document];
        [canvasVC setDocument:document];

        return;
    }
    else if ([selectedNode isKindOfClass:[IUProject class]]){
        return;
    }
    else if ([selectedNode isKindOfClass:[IUDocumentGroupNode class]]){
        return;
    }
    else if ([selectedNode isKindOfClass:[IUResourceGroupNode class]]) {
            return;
    }
    else if ([selectedNode isKindOfClass:[IUResourceNode class]]) {
        return;
    }
}

-(void)startNewProject{
    NSError *error;

    NSDictionary *dict = @{IUProjectKeyAppName: @"myApp",
                           IUProjectKeyGit: @(NO),
                           IUProjectKeyHeroku: @(NO),
                           IUProjectKeyDirectory: [@"~/IUProjTemp" stringByExpandingTildeInPath]};

    NSString *projectPath = [IUProject createProject:dict error:&error];
    if (error != nil) {
        assert(0);
    }
    [self loadProject:projectPath];
}



@end