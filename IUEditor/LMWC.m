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
#import "IUDocumentGroup.h"
#import "IUResourceGroup.h"
#import "IUResourceFile.h"


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
#import "LMCommandVC.h"

#import "LMTopToolbarVC.h"
#import "LMBottomToolbarVC.h"
#import "LMIUInspectorVC.h"

#import "IUDjangoProject.h"

#import "LMProjectConvertWC.h"

@interface LMWC ()

//toolbar
@property (weak) IBOutlet NSView *topToolbarV;
@property (weak) IBOutlet NSView *bottomToolbarV;

//Left
@property (weak) IBOutlet NSLayoutConstraint *leftVConstraint;
@property (weak) IBOutlet NSSplitView *leftV;
@property (weak) IBOutlet NSView *leftTopV;
@property (weak) IBOutlet NSView *leftBottomV;
@property (weak) IBOutlet NSView *commandV;

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

    //VC for view
    //left
    LMFileNaviVC    *fileNaviVC;
    LMStackVC       *stackVC;
    LMCommandVC     *commandVC;
    
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

    
    LMProjectConvertWC *pcWC;
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
    
////////////////left view/////////////////////////    
    stackVC = [[LMStackVC alloc] initWithNibName:@"LMStackVC" bundle:nil];
    [self bind:@"IUController" toObject:stackVC withKeyPath:@"IUController" options:nil];
    [_leftTopV addSubviewFullFrame:stackVC.view];

    
    fileNaviVC = [[LMFileNaviVC alloc] initWithNibName:@"LMFileNaviVC" bundle:nil];
    [self bind:@"selectedNode" toObject:fileNaviVC withKeyPath:@"selection" options:nil];
    [self bind:@"documentController" toObject:fileNaviVC withKeyPath:@"documentController" options:nil];

    [_leftBottomV addSubviewFullFrame:fileNaviVC.view];
    
    commandVC = [[LMCommandVC alloc] initWithNibName:@"LMCommandVC" bundle:nil];
    [_commandV addSubviewFullFrame:commandVC.view];
    [commandVC bind:@"docController" toObject:self withKeyPath:@"documentController" options:nil];

////////////////center view/////////////////////////
    canvasVC = [[LMCanvasVC alloc] initWithNibName:@"LMCanvasVC" bundle:nil];
    [_centerV addSubviewFullFrame:canvasVC.view];
    [canvasVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    
    ((LMWindow*)(self.window)).canvasView =  (LMCanvasView *)canvasVC.view;
    [self bind:@"selectedTextRange" toObject:self withKeyPath:@"selectedTextRange" options:nil];
    
    topToolbarVC = [[LMTopToolbarVC alloc] initWithNibName:@"LMTopToolbarVC" bundle:nil];
    [_topToolbarV addSubviewFullFrame:topToolbarVC.view];
    
    bottomToolbarVC = [[LMBottomToolbarVC alloc] initWithNibName:@"LMBottomToolbarVC" bundle:nil];
    [_bottomToolbarV addSubviewFullFrame:bottomToolbarVC.view];

    
////////////////right view/////////////////////////
    widgetLibraryVC = [[LMWidgetLibraryVC alloc] initWithNibName:@"LMWidgetLibraryVC" bundle:nil];
    [_widgetV addSubviewFullFrame:widgetLibraryVC.view];
    [widgetLibraryVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
    
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
    
    
    //top
    topToolbarVC.documentController = fileNaviVC.documentController;
    
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


-(void)loadProject:(NSString*)path{
    if (path == nil) {
        return;
    }
    //create project class
    _project = [IUProject projectWithContentsOfPath:path];
    NSError *error;
    assert(_project.path);
    assert(_project.pageDocuments);
    assert(_project.identifierManager);
    assert(_project.resourceManager);
    
    if (error) {
        assert(0);
        return;
    }
    if (_project == nil) {
        return;
    }
    
    //load sizeView
    for(NSNumber *number in _project.mqSizes){
        NSInteger frameSize = [number integerValue];
        [canvasVC addFrame:frameSize];
    }
    
    [_project copyResourceForDebug];
    
    
    
    // vc setting
    //construct to file navi
    canvasVC.documentBasePath = _project.path;
    canvasVC.resourceManager = _project.resourceManager;
    fileNaviVC.project = _project;
    assert(widgetLibraryVC.project == nil);
    widgetLibraryVC.project = _project;
    resourceVC.manager = _project.resourceManager;
    
    
    //construct widget library vc
    [widgetLibraryVC setProject:_project];
    NSString *widgetFilePath = [[NSBundle mainBundle] pathForResource:@"widgetForDefault" ofType:@"plist"];
    NSArray *availableWidgetProperties = [NSArray arrayWithContentsOfFile:widgetFilePath];
    [widgetLibraryVC setWidgetProperties:availableWidgetProperties];
    iuInspectorVC.resourceManager = _project.resourceManager;
    

    //FIXME: remove page documents
    //iuInspectorVC.pageDocumentNodes = _project.pageDocumentNodes;
    //iuInspectorVC.classDocumentNodes = _project.classDocumentNodes;
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:path]];
    
    [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"lastDocument"];
    [self.window setTitleWithRepresentedFilename:path];
    [self.window setTitle:[NSString stringWithFormat:@"[%@] %@", [_project.className substringFromIndex:2], _project.path]];
    
    //finished. load file
    [fileNaviVC selectFirstDocument];
}

-(void)setSelectedNode:(NSObject*)selectedNode{
    _selectedNode = (IUDocument*) selectedNode;
    if ([selectedNode isKindOfClass:[IUDocument class]]) {
        [stackVC setDocument:_selectedNode];
        [canvasVC setDocument:_selectedNode];
        [bottomToolbarVC setDocument:_selectedNode];
//        [topToolbarVC setDocumentNode:document];
        
        //save for debug
        NSString *documentSavePath = [canvasVC.documentBasePath stringByAppendingPathComponent:[_selectedNode.name stringByAppendingPathExtension:@"html"]];
        [_selectedNode.editorSource writeToFile:documentSavePath atomically:YES encoding:NSUTF8StringEncoding error:nil];


        return;
    }
    else if ([selectedNode isKindOfClass:[IUProject class]]){
        return;
    }
    else if ([selectedNode isKindOfClass:[IUDocumentGroup class]]){
        return;
    }
    else if ([selectedNode isKindOfClass:[IUResourceGroup class]]) {
        return;
    }
    else if ([selectedNode isKindOfClass:[IUResourceFile class]]) {
        return;
    }
}

- (void)reloadCurrentDocument{
    assert(0);
    /*
    if ([_selectedNode isKindOfClass:[IUDocumentGroup class]]) {
        IUDocument *document = ((IUDocumentGroup*)_selectedNode).document;
        [canvasVC setDocument:document];
    }
     */
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


- (IBAction)convertProject:(id)sender{
    //call from menu item
    pcWC = [[LMProjectConvertWC alloc] initWithWindowNibName:@"LMProjectConvertWC"];
    pcWC.currentProject = _project;
    
    [self.window beginSheet:pcWC.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
}


@end