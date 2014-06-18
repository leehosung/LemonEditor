//
//  LMWC.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMWC.h"
#import "LMWindow.h"

#import "IUSheetController.h"
#import "IUProject.h"
#import "IUSheetGroup.h"
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
#import "LMIUPropertyVC.h"

#import "IUDjangoProject.h"

#import "LMProjectConvertWC.h"
#import "IUProjectDocument.h"

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
@property (weak) IBOutlet NSMatrix *clickWidgetTabMatrix;
@property (weak) IBOutlet NSView *widgetV;
@property (weak) IBOutlet NSView *resourceV;

//canvas
@property (weak) IBOutlet NSView *centerV;
@property (weak) IBOutlet NSMatrix *propertyMatrix;
@property (weak) IBOutlet NSMatrix *widgetMatrix;

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
    LMIUPropertyVC  *iuInspectorVC;
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
        //allocation
        stackVC = [[LMStackVC alloc] initWithNibName:@"LMStackVC" bundle:nil];
        fileNaviVC = [[LMFileNaviVC alloc] initWithNibName:@"LMFileNaviVC" bundle:nil];
        commandVC = [[LMCommandVC alloc] initWithNibName:@"LMCommandVC" bundle:nil];
        canvasVC = [[LMCanvasVC alloc] initWithNibName:@"LMCanvasVC" bundle:nil];
        topToolbarVC = [[LMTopToolbarVC alloc] initWithNibName:@"LMTopToolbarVC" bundle:nil];
        bottomToolbarVC = [[LMBottomToolbarVC alloc] initWithNibName:@"LMBottomToolbarVC" bundle:nil];
        widgetLibraryVC = [[LMWidgetLibraryVC alloc] initWithNibName:@"LMWidgetLibraryVC" bundle:nil];
        resourceVC = [[LMResourceVC alloc] initWithNibName:@"LMResourceVC" bundle:nil];
        appearanceVC = [[LMAppearanceVC alloc] initWithNibName:@"LMAppearanceVC" bundle:nil];
        iuInspectorVC = [[LMIUPropertyVC alloc] initWithNibName:[LMIUPropertyVC class].className bundle:nil];
        eventVC = [[LMEventVC alloc] initWithNibName:@"LMEventVC" bundle:nil];

        
        //bind
        [self bind:@"IUController" toObject:stackVC withKeyPath:@"IUController" options:nil];
        [self bind:@"selectedNode" toObject:fileNaviVC withKeyPath:@"selection" options:nil];
        [self bind:@"documentController" toObject:fileNaviVC withKeyPath:@"documentController" options:nil];
        [commandVC bind:@"docController" toObject:self withKeyPath:@"documentController" options:nil];
        [canvasVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [self bind:@"selectedTextRange" toObject:self withKeyPath:@"selectedTextRange" options:nil];
        [widgetLibraryVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [appearanceVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [iuInspectorVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [eventVC bind:@"controller" toObject:self withKeyPath:@"IUController" options:nil];
        [topToolbarVC bind:@"sheetController" toObject:fileNaviVC withKeyPath:@"documentController" options:nil];
        
        
        //project binding
        [canvasVC bind:@"documentBasePath" toObject:self withKeyPath:@"document.project.path" options:nil];
        [iuInspectorVC bind:@"classDocuments" toObject:self withKeyPath:@"document.project.classDocuments" options:nil];
    }
    return self;
}



- (void)windowDidLoad
{
    [_leftTopV addSubviewFullFrame:stackVC.view];
    [_leftBottomV addSubviewFullFrame:fileNaviVC.view];
    [_commandV addSubviewFullFrame:commandVC.view];

    
    ////////////////center view/////////////////////////
    [_centerV addSubviewFullFrame:canvasVC.view];
    
    ((LMWindow*)(self.window)).canvasView =  (LMCanvasView *)canvasVC.view;
    
    [_topToolbarV addSubviewFullFrame:topToolbarVC.view];
    [_bottomToolbarV addSubviewFullFrame:bottomToolbarVC.view];
    
    
    ////////////////right view/////////////////////////
    [_widgetV addSubviewFullFrame:widgetLibraryVC.view];
    
    [_resourceV addSubviewFullFrame:resourceVC.view];
    
    [_appearanceV addSubviewFullFrame:appearanceVC.view];
    
    
    [_propertyV addSubviewFullFrame:iuInspectorVC.view];
    
    [_eventV addSubviewFullFrame:eventVC.view];
    
    

    
#pragma mark - inspector view
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showLeftInspector" options:NSKeyValueObservingOptionInitial context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showRightInspector" options:NSKeyValueObservingOptionInitial context:nil];
        
}


- (void)awakeFromNib{
    NSCell *cell = [self.propertyMatrix cellAtRow:0 column:0];
    [self.propertyMatrix setToolTip:@"Appearance" forCell:cell];
    
    NSCell *cell2 = [self.propertyMatrix cellAtRow:0 column:1];
    [self.propertyMatrix setToolTip:@"Property" forCell:cell2];

    NSCell *cell3 = [self.propertyMatrix cellAtRow:0 column:2];
    [self.propertyMatrix setToolTip:@"Event" forCell:cell3];

    
    NSCell *cell4 = [self.widgetMatrix cellAtRow:0 column:0];
    [self.widgetMatrix setToolTip:@"Widget" forCell:cell4];
    
    NSCell *cell5 = [self.widgetMatrix cellAtRow:0 column:1];
    [self.widgetMatrix setToolTip:@"Library" forCell:cell5];
    
    NSCell *cell6 = [self.widgetMatrix cellAtRow:0 column:2];
    [self.widgetMatrix setToolTip:@"Clipart" forCell:cell6];
    
    
    NSCell *cell7 = [self.clickWidgetTabMatrix cellAtRow:0 column:0];
    [self.clickWidgetTabMatrix setToolTip:@"Primary Widget" forCell:cell7];
    
    NSCell *cell8 = [self.clickWidgetTabMatrix cellAtRow:0 column:1];
    [self.clickWidgetTabMatrix setToolTip:@"Secondary Widget" forCell:cell8];
    

}

- (void)dealloc{
    //release 시점 확인용
    assert(0);
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

- (void)setDocument:(IUProjectDocument *)document{
    //create project class
    [super setDocument:document];
    
    //document == nil means window will be closed
    if(document){
        _project = document.project;
        //[canvasVC bind:@"documentBasePath" toObject:_project withKeyPath:@"path" options:nil];
        NSError *error;
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
        
        //vc setting
        
        //construct widget library vc
        NSString *widgetFilePath = [[NSBundle mainBundle] pathForResource:@"widgetForDefault" ofType:@"plist"];
        NSArray *availableWidgetProperties = [NSArray arrayWithContentsOfFile:widgetFilePath];
        [widgetLibraryVC setWidgetProperties:availableWidgetProperties];
        
        //set project
        fileNaviVC.project = _project;
        widgetLibraryVC.project = _project;
        [widgetLibraryVC setProject:_project];

        //set ResourceManager
        canvasVC.resourceManager = _project.resourceManager;
        resourceVC.manager = _project.resourceManager;
        appearanceVC.resourceManager = _project.resourceManager;
        iuInspectorVC.resourceManager = _project.resourceManager;
        bottomToolbarVC.resourceManager = _project.resourceManager;
        
    }
}

- (void)selectFirstDocument{
    [fileNaviVC selectFirstDocument];
}

#if 0
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
    appearanceVC.resourceManager = _project.resourceManager;
    topToolbarVC.documentController = _documentController;
    
    
    //construct widget library vc
    [widgetLibraryVC setProject:_project];
    NSString *widgetFilePath = [[NSBundle mainBundle] pathForResource:@"widgetForDefault" ofType:@"plist"];
    NSArray *availableWidgetProperties = [NSArray arrayWithContentsOfFile:widgetFilePath];
    [widgetLibraryVC setWidgetProperties:availableWidgetProperties];
    iuInspectorVC.resourceManager = _project.resourceManager;
    

    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:path]];
    
    [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"lastDocument"];
    [self.window setTitleWithRepresentedFilename:path];
    [self.window setTitle:[NSString stringWithFormat:@"[%@] %@", [_project.className substringFromIndex:2], _project.path]];
    
    //finished. load file
    [fileNaviVC selectFirstDocument];
}
#endif

-(void)setSelectedNode:(NSObject*)selectedNode{
    _selectedNode = (IUSheet*) selectedNode;
    if ([selectedNode isKindOfClass:[IUSheet class]]) {
        [stackVC setSheet:_selectedNode];
        [canvasVC setSheet:_selectedNode];
        [bottomToolbarVC setSheet:_selectedNode];
        [topToolbarVC setSheet:_selectedNode];
        
        //save for debug
        /*
        //remove this line : saving can't not in the package
        NSString *documentSavePath = [canvasVC.documentBasePath stringByAppendingPathComponent:[_selectedNode.name stringByAppendingPathExtension:@"html"]];
        [_selectedNode.editorSource writeToFile:documentSavePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
         */


        return;
    }
    else if ([selectedNode isKindOfClass:[IUProject class]]){
        return;
    }
    else if ([selectedNode isKindOfClass:[IUSheetGroup class]]){
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
    if ([_selectedNode isKindOfClass:[IUSheet class]]) {
        [canvasVC setSheet:_selectedNode];
    }
}



#pragma mark -
#if 0
- (void)saveDocument:(id)sender{
    JDInfoLog(@"saving document");
    [_project save];
}
#endif

- (void)addMQSize:(NSInteger)size{
    [_project addMQSize:size];
}

- (void)removeMQSize:(NSInteger)size{
    [_project removeMQSize:size];
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
