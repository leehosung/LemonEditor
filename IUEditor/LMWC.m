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
#import "LMPropertyBaseVC.h"
#import "IUCompiler.h"
#import "IUResourceManager.h"
#import "IUIdentifierManager.h"
#import "LMAppearanceVC.h"

@interface LMWC ()

//toolbar (bottom)
@property (weak) IBOutlet NSView *toolbarV;

//Left
@property (weak) IBOutlet NSView *leftTopV;
@property (weak) IBOutlet NSView *leftBottomV;

//Right-top
@property (weak) IBOutlet NSTabView *propertyV;
@property (weak) IBOutlet NSView *appearanceV;

//Right-bottom
@property (weak) IBOutlet NSTabView *widgetTabV;

@property (weak) IBOutlet NSView *widgetV;
@property (weak) IBOutlet NSView *resourceV;

//befor merge


@property (weak) IBOutlet NSView *centerV;
@property (weak) IBOutlet NSView *propertyBaseV;

@end

@implementation LMWC{
    IUProject   *_project;
    IUCompiler  *_compiler;
    IUResourceManager   *_resourceManager;
    IUIdentifierManager *_identifierManager;

    LMFileNaviVC    *fileNaviVC;
    LMStackVC       *stackVC;
    LMCanvasVC *canvasVC;
    LMWidgetLibraryVC   *widgetLibraryVC;
    LMToolbarVC     *toolbarVC;
    LMResourceVC    *resourceVC;

    LMPropertyBaseVC    *propertyBaseVC;
    
    LMAppearanceVC  *appearanceVC;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _identifierManager = [[IUIdentifierManager alloc] init];
        _resourceManager = [[IUResourceManager alloc] init];
    }
    return self;
}


- (void)windowDidLoad
{
    
    //Setting For LeftView
    stackVC = [[LMStackVC alloc] initWithNibName:@"LMStackVC" bundle:nil];
    [self bind:@"IUController" toObject:stackVC withKeyPath:@"IUController" options:nil];
    [_leftTopV addSubviewFullFrame:stackVC.view];

    
    fileNaviVC = [[LMFileNaviVC alloc] initWithNibName:@"LMFileNaviVC" bundle:nil];
    [self bind:@"selectedNode" toObject:fileNaviVC withKeyPath:@"selection" options:nil];
    [self bind:@"documentController" toObject:fileNaviVC withKeyPath:@"documentController" options:nil];
    [_leftBottomV addSubviewFullFrame:fileNaviVC.view];
    

    
    canvasVC = [[LMCanvasVC alloc] initWithNibName:@"LMCanvasVC" bundle:nil];
    [_centerV addSubviewFullFrame:canvasVC.view];
    [canvasVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    self.window.canvasView =  (LMCanvasView *)canvasVC.view;
    
    widgetLibraryVC = [[LMWidgetLibraryVC alloc] initWithNibName:@"LMWidgetLibraryVC" bundle:nil];
    [_widgetV addSubviewFullFrame:widgetLibraryVC.view];
    [widgetLibraryVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    [widgetLibraryVC setIdentifierManager:_identifierManager];
    
    toolbarVC = [[LMToolbarVC alloc] initWithNibName:@"LMToolbarVC" bundle:nil];
    [_toolbarV addSubviewFullFrame:toolbarVC.view];
    
    resourceVC = [[LMResourceVC alloc] initWithNibName:@"LMResourceVC" bundle:nil];
    [_resourceV addSubviewFullFrame:resourceVC.view];
    
    appearanceVC = [[LMAppearanceVC alloc] initWithNibName:@"LMAppearanceVC" bundle:nil];
    [appearanceVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    [_appearanceV addSubviewFullFrame:appearanceVC.view];
    
       
    propertyBaseVC = [[LMPropertyBaseVC alloc] initWithNibName:[LMPropertyBaseVC class].className bundle:nil];
    [propertyBaseVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    [_propertyBaseV addSubviewFullFrame:propertyBaseVC.view];
    
}

-(LMWindow*)window{
    return (LMWindow*)[super window];
}


-(void)loadProject:(NSString*)path{
    //create project class
    _project = [IUProject projectWithContentsOfPackage:path];
    if (_project == nil) {
        return;
    }
    _project.delegate = self;
    
    //IU Setting
    _compiler = [[IUCompiler alloc] init];
    _resourceManager.rootNode = _project.resourceNode;
    _compiler.resourceSource = _resourceManager;
    
    NSArray *documensNode = [_project.allChildren filteredArrayWithClass:[IUDocumentNode class]];
    
    for (IUDocumentNode *node in documensNode) {
        [node.document setCompiler:_compiler];
        [node.document setIdentifierManager:_identifierManager];
    }

    // vc setting
    //construct toolbar
    toolbarVC.documentController = fileNaviVC.documentController;
    
    //construct to file navi
    canvasVC.documentBasePath = _project.absolutePath;
    fileNaviVC.project = _project;
    [fileNaviVC selectFirstDocument];
    
    //construct widget library vc
    [widgetLibraryVC setProject:_project];
    NSString *widgetFilePath = [[NSBundle mainBundle] pathForResource:@"widgetForDefault" ofType:@"plist"];
    NSArray *availableWidgetProperties = [NSArray arrayWithContentsOfFile:widgetFilePath];
    [widgetLibraryVC setWidgetProperties:availableWidgetProperties];
    

    //construct resource vc
    [resourceVC setManager:_resourceManager];
    
    //construct property vc
    [appearanceVC.propertyBGImageVC setResourceManager:_resourceManager];
    propertyBaseVC.pageDocumentNodes = _project.pageDocumentNodes;
}

-(void)setSelectedNode:(IUNode*)selectedNode{
    _selectedNode = selectedNode;
    if ([selectedNode isKindOfClass:[IUDocumentNode class]]) {
        IUDocument *document = ((IUDocumentNode*)selectedNode).document;
        [stackVC setDocument:document];
        [canvasVC setDocument:document];
        
        //save for debug
        NSString *documentSavePath = [canvasVC.documentBasePath stringByAppendingPathComponent:[selectedNode.name stringByAppendingPathExtension:@"html"]];
        [document.editorSource writeToFile:documentSavePath atomically:YES encoding:NSUTF8StringEncoding error:nil];


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





#pragma mark -
//TODO: remove it :(test button)
- (IBAction)getCurrentSource:(id)sender{
    [canvasVC showCurrentSource];
}

- (void)saveDocument:(id)sender{
    JDInfoLog(@"saving document");
    [_project save];
}


- (void)project:(IUProject *)project nodeAdded:(IUNode *)node{
    [propertyBaseVC setPageDocumentNodes:project.pageDocumentNodes];
}

#pragma mark -
#pragma mark select TavView

- (IBAction)clickPropertyMatrix:(id)sender {
    NSMatrix *propertyMatrix = sender;
    NSInteger index = [propertyMatrix selectedColumn];
    
    [_propertyV selectTabViewItemAtIndex:index];
}
- (IBAction)clickWidgetMatrix:(id)sender {
    NSMatrix *propertyMatrix = sender;
    NSInteger index = [propertyMatrix selectedColumn];
    
    [_widgetTabV selectTabViewItemAtIndex:index];

}

@end