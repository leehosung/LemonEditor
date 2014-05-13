//
//  LMWC.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMWC.h"
#import "LMWindow.h"

#import "IUDocumentController.h"
#import "IUProject.h"
#import "IUDocumentNode.h"
#import "IUResourceGroupNode.h"
#import "IUResourceNode.h"

#import "IUCompiler.h"

#import "IUResourceManager.h"
#import "IUIdentifierManager.h"

//connect VC
#import "LMAppearanceVC.h"
#import "LMResourceVC.h"
#import "LMFileNaviVC.h"
#import "LMStackVC.h"
#import "LMWidgetLibraryVC.h"
#import "LMCanvasVC.h"
#import "LMEventVC.h"

#import "LMTopToolbarVC.h"
#import "LMBottomToolbarVC.h"
#import "LMIUInspectorVC.h"

#import "IUDjangoProject.h"

@interface LMWC ()

//toolbar
@property (weak) IBOutlet NSView *topToolbarV;
@property (weak) IBOutlet NSView *bottomToolbarV;

//Left
@property (weak) IBOutlet NSLayoutConstraint *leftVConstraint;
@property (weak) IBOutlet NSSplitView *leftV;
@property (weak) IBOutlet NSView *leftTopV;
@property (weak) IBOutlet NSView *leftBottomV;

//Right-V
@property (weak) IBOutlet NSSplitView *rightV;
@property (weak) IBOutlet NSLayoutConstraint *rightVConstraint;

//Right-top
@property (weak) IBOutlet NSTabView *propertyTabV;

@property (weak) IBOutlet NSView *propertyV;
@property (weak) IBOutlet NSView *appearanceV;
@property (weak) IBOutlet NSView *eventV;

//Right-bottom
@property (weak) IBOutlet NSTabView *widgetTabV;

@property (weak) IBOutlet NSView *widgetV;
@property (weak) IBOutlet NSView *resourceV;

//canvas
@property (weak) IBOutlet NSView *centerV;

@end

@implementation LMWC{
    IUProject   *_project;
    IUCompiler  *_compiler;
    IUResourceManager   *_resourceManager;
    IUIdentifierManager *_identifierManager;

    //VC for view
    //left
    LMFileNaviVC    *fileNaviVC;
    LMStackVC       *stackVC;
    
    //center
    LMCanvasVC *canvasVC;
    LMTopToolbarVC  *topToolbarVC;
    LMBottomToolbarVC     *bottomToolbarVC;
    
    //right top
    LMIUInspectorVC  *iuInspectorVC;
    LMAppearanceVC  *appearanceVC;
    LMEventVC       *eventVC;
    
    //right bottom
    LMWidgetLibraryVC   *widgetLibraryVC;
    LMResourceVC    *resourceVC;

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
    
////////////////left view/////////////////////////    
    stackVC = [[LMStackVC alloc] initWithNibName:@"LMStackVC" bundle:nil];
    [self bind:@"IUController" toObject:stackVC withKeyPath:@"IUController" options:nil];
    [_leftTopV addSubviewFullFrame:stackVC.view];

    
    fileNaviVC = [[LMFileNaviVC alloc] initWithNibName:@"LMFileNaviVC" bundle:nil];
    [self bind:@"selectedNode" toObject:fileNaviVC withKeyPath:@"selection" options:nil];
    [self bind:@"documentController" toObject:fileNaviVC withKeyPath:@"documentController" options:nil];
    [fileNaviVC setIdentifierManager:_identifierManager];
    [_leftBottomV addSubviewFullFrame:fileNaviVC.view];
    
    

////////////////center view/////////////////////////
    canvasVC = [[LMCanvasVC alloc] initWithNibName:@"LMCanvasVC" bundle:nil];
    [_centerV addSubviewFullFrame:canvasVC.view];
    [canvasVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    canvasVC.resourceManager = _resourceManager;
    self.window.canvasView =  (LMCanvasView *)canvasVC.view;
    [self bind:@"selectedTextRange" toObject:self withKeyPath:@"selectedTextRange" options:nil];
    
    topToolbarVC = [[LMTopToolbarVC alloc] initWithNibName:@"LMTopToolbarVC" bundle:nil];
    [_topToolbarV addSubviewFullFrame:topToolbarVC.view];
    
    bottomToolbarVC = [[LMBottomToolbarVC alloc] initWithNibName:@"LMBottomToolbarVC" bundle:nil];
    [_bottomToolbarV addSubviewFullFrame:bottomToolbarVC.view];

////////////////right view/////////////////////////
    widgetLibraryVC = [[LMWidgetLibraryVC alloc] initWithNibName:@"LMWidgetLibraryVC" bundle:nil];
    [_widgetV addSubviewFullFrame:widgetLibraryVC.view];
    [widgetLibraryVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    [widgetLibraryVC setIdentifierManager:_identifierManager];
    
    
    resourceVC = [[LMResourceVC alloc] initWithNibName:@"LMResourceVC" bundle:nil];
    [_resourceV addSubviewFullFrame:resourceVC.view];
    
    appearanceVC = [[LMAppearanceVC alloc] initWithNibName:@"LMAppearanceVC" bundle:nil];
    [appearanceVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    [_appearanceV addSubviewFullFrame:appearanceVC.view];
    
       
    iuInspectorVC = [[LMIUInspectorVC alloc] initWithNibName:[LMIUInspectorVC class].className bundle:nil];
    [iuInspectorVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    [_propertyV addSubviewFullFrame:iuInspectorVC.view];
    
    eventVC = [[LMEventVC alloc] initWithNibName:@"LMEventVC" bundle:nil];
    [eventVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    [_eventV addSubviewFullFrame:eventVC.view];
    
#pragma mark - inspector view
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showLeftInspector" options:NSKeyValueObservingOptionInitial context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showRightInspector" options:NSKeyValueObservingOptionInitial context:nil];
    
}

-(void)showLeftInspectorDidChange:(NSDictionary *)change{
    BOOL showLeftInspector = [[NSUserDefaults standardUserDefaults] boolForKey:@"showLeftInspector"];
    [_leftV setHidden:!showLeftInspector];
    if(showLeftInspector){
        [_leftVConstraint setConstant:0];
    }
    else{
        [_leftVConstraint setConstant:-220];
    }
}

-(void)showRightInspectorDidChange:(NSDictionary *)change{
    BOOL showRightInspector = [[NSUserDefaults standardUserDefaults] boolForKey:@"showRightInspector"];
    [_rightV setHidden:!showRightInspector];
    
    if(showRightInspector){
        [_rightVConstraint setConstant:0];
    }
    else{
        [_rightVConstraint setConstant:-300];
    }
}

-(LMWindow*)window{
    return (LMWindow*)[super window];
}

- (void)setNewFileNode:(IUDocumentNode *)node{
    [node.document setCompiler:_compiler];
    [node.document setIdentifierManager:_identifierManager];
    [_identifierManager addIU:node.document];
}

-(void)loadProject:(NSString*)path{
    //create project class
    _project = [IUProject projectWithContentsOfPackage:path];
    NSError *error;
//    _project = [IUDjangoProject convertProject:_project setting:@{IUProjectKeyAppName:@"IUEditorHome", IUProjectKeyDirectory:@"/Users/jd/IUProjTemp/IUEditorHome"} error:&error];
    
    if (error) {
        assert(0);
        return;
    }
    _project.path = path;
    if (_project == nil) {
        return;
    }
    
    //load sizeView
    for(NSNumber *number in _project.mqSizes){
        NSInteger frameSize = [number integerValue];
        [canvasVC addFrame:frameSize];
    }
    
    [_project copyResourceForDebug];

    _project.delegate = self;
    
    //IU Setting
    _compiler = [[IUCompiler alloc] init];
    _resourceManager.rootNode = _project.resourceNode;
    _compiler.resourceSource = _resourceManager;
    if ([_project isKindOfClass:[IUDjangoProject class]]) {
        _compiler.rule = IUCompileRuleDjango;
    }
    else {
        _compiler.rule = IUCompileRuleDefault;
    }
    
    NSArray *documensNode = [_project.allChildren filteredArrayWithClass:[IUDocumentNode class]];
    
    for (IUDocumentNode *node in documensNode) {
        [node.document setCompiler:_compiler];
        [node.document setIdentifierManager:_identifierManager];
        [_identifierManager addIU:node.document];
    }

    // vc setting
    //construct toolbar
    topToolbarVC.documentController = fileNaviVC.documentController;
    
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
    [iuInspectorVC setResourceManager:_resourceManager];
    [bottomToolbarVC setResourceManager:_resourceManager];
    iuInspectorVC.pageDocumentNodes = _project.pageDocumentNodes;
    iuInspectorVC.classDocumentNodes = _project.classDocumentNodes;
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:path]];
    
    [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"lastDocument"];
    self.window.title = path;
}

-(void)setSelectedNode:(IUNode*)selectedNode{
    _selectedNode = selectedNode;
    if ([selectedNode isKindOfClass:[IUDocumentNode class]]) {
        IUDocument *document = ((IUDocumentNode*)selectedNode).document;
        [stackVC setDocument:document];
        [canvasVC setDocument:document];
        [bottomToolbarVC setDocument:document];
        [topToolbarVC setDocumentNode:(IUDocumentNode *)selectedNode];
        
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

- (void)reloadCurrentDocument{
    if ([_selectedNode isKindOfClass:[IUDocumentNode class]]) {
        IUDocument *document = ((IUDocumentNode*)_selectedNode).document;
        [canvasVC setDocument:document];
    }
}


#pragma mark -
- (void)saveDocument:(id)sender{
    JDInfoLog(@"saving document");
    [_project save];
}

- (void)addMQSize:(NSInteger)size{
    [_project.mqSizes addObject:@(size)];
}
- (void)removeMQSize:(NSInteger)size{
    [_project.mqSizes removeObject:@(size)];
}


#pragma mark -
#pragma mark select TavView

- (IBAction)clickPropertyMatrix:(id)sender {
    NSMatrix *propertyMatrix = sender;
    NSInteger index = [propertyMatrix selectedColumn];
    
    [_propertyTabV selectTabViewItemAtIndex:index];
}
- (IBAction)clickWidgetMatrix:(id)sender {
    NSMatrix *propertyMatrix = sender;
    NSInteger index = [propertyMatrix selectedColumn];
    
    [_widgetTabV selectTabViewItemAtIndex:index];

}


#pragma mark -
#pragma mark IUProjectDelegate
-(void)project:(IUProject*)project nodeAdded:(IUNode*)node{
    
}
-(void)project:(IUProject*)project nodeRemoved:(IUNode*)node{
    
}


@end