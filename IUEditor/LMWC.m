//
//  LMWC.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMWC.h"

#import "CanvasWindow.h"
#import "JDLogUtil.h"
#import "SizeView.h"

#import "LMFileNaviVC.h"
#import "LMStackVC.h"
//#import "LMCanvasV.h"
#import "LMWidgetLibraryVC.h"

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
//    LMCanvasV       *canvasV;
    LMWidgetLibraryVC   *widgetLibraryVC;
    LMToolbarVC     *toolbarVC;
    LMResourceVC    *resourceVC;

    IUProject   *_project;
    
    /*
     **********************
     CanvasWC
     **********************
     */
    NSMutableArray *selectedIUs;
    IUFrameDictionary *frameDict;

}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        frameDict = [[IUFrameDictionary alloc] init];;
        selectedIUs = [NSMutableArray array];
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

//    canvasV = [[LMCanvasV alloc] init];
  //  [_centerV addSubviewFullFrame:canvasV];
    
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
//    canvasV.resourcePath = _project.path;
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
        [self loadHTMLString:document.editorSource baseURL:[NSURL fileURLWithPath:_project.path]];
//        [canvasV setDocument:document];
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

#pragma mark -
#pragma mark Canvas WC

#pragma mark -
#pragma mark window delegate

-(void)windowDidResize:(NSNotification *)notification{
    CGFloat selectedWidth =  [[self sizeView] selectedFrameWidth];
    [((CanvasWindow *)self.window) setWidthOfMainView:selectedWidth];
}

#pragma mark -
#pragma mark sizeView


- (SizeView *)sizeView{
    return ((CanvasWindow *)self.window).sizeView;
    
}
- (void)addFrame:(NSInteger)width{
    [[self sizeView] addFrame:width];
}
- (void)removeFrame:(NSInteger)width{
    [[self sizeView] removeFrame:width];
}

#pragma mark -
#pragma mark webView
- (WebCanvasView *)webView{
    return ((CanvasWindow *)self.window).webView;
}

- (DOMDocument *)DOMDoc{
    return [[[self webView] mainFrame] DOMDocument];
}

- (void)loadRequest:(NSURLRequest *)request{
    [[((CanvasWindow *)self.window).webView mainFrame] loadRequest:request];
}

- (void)loadHTMLString:(NSString *)htmlString baseURL:(NSURL *)URL{
    [[((CanvasWindow *)self.window).webView mainFrame] loadHTMLString:htmlString baseURL:URL];
}

#pragma mark -
#pragma mark manage IUs
- (BOOL)containsIU:(NSString *)IU{
    if ([selectedIUs containsObject:IU]){
        return YES;
    }
    else {
        return NO;
    }
}
- (void)removeSelectedAllIUs{
    [selectedIUs removeAllObjects];
    [[self gridView] removeAllRedPointLayer];
    [[self gridView] removeAllTextPointLayer];
}
- (void)addSelectedIU:(NSString *)IU{
    [selectedIUs addObject:IU];
    if([frameDict.dict objectForKey:IU]){
        NSRect frame = [[frameDict.dict objectForKey:IU] rectValue];
        [[self gridView] addRedPointLayer:IU withFrame:frame];
        [[self gridView] addTextPointLayer:IU withFrame:frame];
    }
}

- (void)selectIUInRect:(NSRect)frame{
    NSArray *keys = [frameDict.dict allKeys];
    
    [self removeSelectedAllIUs];
    
    for(NSString *key in keys){
        NSRect iuframe = [[frameDict.dict objectForKey:key] rectValue];
        if( NSIntersectsRect(iuframe, frame) ){
            [self addSelectedIU:key];
        }
    }
}

#pragma mark -
#pragma mark HTML

- (DOMHTMLElement *)getHTMLElementbyID:(NSString *)HTMLID{
    DOMHTMLElement *selectNode = (DOMHTMLElement *)[self.DOMDoc getElementById:HTMLID];
    return selectNode;
    
}

//remake html
- (void)setIUInnerHTML:(NSString *)HTML withParentID:(NSString *)parentID tag:(NSString *)tag{
    
    DOMHTMLElement *selectHTMLElement = [self getHTMLElementbyID:parentID];
    DOMHTMLElement *newElement = (DOMHTMLElement *)[self.DOMDoc createElement:tag];
    [selectHTMLElement appendChild:newElement];
    selectHTMLElement.innerHTML = HTML;
    
    [self.webView setNeedsDisplay:YES];
}
//remove IU - delete html & css
- (void)removeIU:(NSString *)iuID{
    //remove HTML
    DOMHTMLElement *selectHTMLElement = [self getHTMLElementbyID:iuID];
    DOMElement *parentElement = [selectHTMLElement parentElement];
    [parentElement removeChild:selectHTMLElement];
    
    
    //TODO: remove CSS
    // - 꼭 필요한가??
    
    
}

#pragma mark -
#pragma mark CSS

- (DOMCSSStyleSheet *)defaultStyleSheet{
    DOMStyleSheetList *list = [[self DOMDoc] styleSheets];
    for(unsigned index =0 ; index < list.length; index++){
        DOMCSSStyleSheet *sheet = (DOMCSSStyleSheet *)[list item:index];
        if(sheet.media.mediaText == nil
           || sheet.media.mediaText.length == 0){
            return sheet;
        }
    }
    return nil;
}

- (DOMCSSStyleSheet *)styleSheetWithSize:(NSInteger)size{
    NSString *sizeStr = [NSString stringWithFormat:@"%ld", size];
    DOMStyleSheetList *list = [[self DOMDoc] styleSheets];
    for(unsigned i =0 ; i < list.length; i++){
        DOMCSSStyleSheet *sheet = (DOMCSSStyleSheet *)[list item:i];
        if([sheet.media.mediaText rangeOfString:sizeStr].length != 0){
            return sheet;
        }
    }
    
    return nil;
    
}
- (void)makeNewStyleSheet:(NSInteger)size{
    
    DOMElement *newSheet = [[self DOMDoc] createElement:@"style"];
    NSString *mediaName = [NSString stringWithFormat:@"screen and (max-width:%ldpx)", size];
    [newSheet setAttribute:@"type" value:@"text/css"];
    [newSheet setAttribute:@"media" value:mediaName];
    [newSheet appendChild:[[self DOMDoc] createTextNode:@""]];
    DOMNode *headNode = [[[self DOMDoc] getElementsByTagName:@"head"] item:0];
    [headNode appendChild:newSheet];
}

- (NSInteger)indexOfIDAtStyleSheet:(DOMCSSStyleSheet *)styleSheet withID:(NSString *)iuID{
    DOMCSSRuleList *lists = [styleSheet rules];
    for(unsigned i=0; i<lists.length; i++){
        DOMCSSRule *rule = [lists item:i];
        
        NSArray *cssArray = [rule.cssText componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#{"]];
        NSString *ruleID = [cssArray[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([ruleID isEqualToString:iuID]){
            return i;
        }
    }
    return -1;
}

//set default css
- (void)setIUStyle:(NSString *)cssText withID:(NSString *)iuID{
    DOMCSSStyleSheet *currentSheet = [self defaultStyleSheet];
    assert(currentSheet != nil);
    [self setCSSRuleInStyleSheet:currentSheet rule:cssText withID:iuID];
}
//set media query css
- (void)setIUStyle:(NSString *)cssText withID:(NSString *)iuID size:(NSInteger)size{
    DOMCSSStyleSheet *currentSheet = [self styleSheetWithSize:size];
    if(currentSheet == nil){
        [self makeNewStyleSheet:size];
        currentSheet = [self styleSheetWithSize:size];
    }
    
    assert(currentSheet != nil);
    
    [self setCSSRuleInStyleSheet:currentSheet rule:cssText withID:iuID];
    
}

- (void)setCSSRuleInStyleSheet:(DOMCSSStyleSheet *)styleSheet rule:(NSString *)rule withID:(NSString *)iuID{
    NSInteger index = [self indexOfIDAtStyleSheet:styleSheet withID:iuID];
    if(index >= 0){
        //delete rule before change
        [styleSheet deleteRule:(unsigned)index];
    }
    [styleSheet insertRule:rule index:0];
    [[self webView] updateFrameDict];
}

#pragma mark -
#pragma mark GridView
- (GridView *)gridView{
    return ((CanvasWindow *)self.window).gridView;
}


#pragma mark -
#pragma mark border, ghost view
- (void)setBorder:(BOOL)border{
    [[self gridView] setBorder:border];
}
- (void)setGhost:(BOOL)ghost{
    [[self gridView] setGhost:ghost];
}
- (void)setGhostImage:(NSImage *)ghostImage{
    [[self gridView] setGhostImage:ghostImage];
}
- (void)setGhostPosition:(NSPoint)position{
    [[self gridView] setGhostPosition:position];
}

/*
 ******************************************************************************************
 SET IU : View call IU
 ******************************************************************************************
 */
#pragma mark -
#pragma mark setIU

#pragma mark frameDict

- (void)updateIUFrameDictionary:(NSMutableDictionary *)iuFrameDict{
    IULog(@"report updated frame dict");
    
    
    //TODO: updated frame dict to IU
}

- (void)updateGridFrameDictionary:(NSMutableDictionary *)gridFrameDict{
    
    [[self gridView] updateLayerRect:gridFrameDict];
    
    
    NSArray *keys = [gridFrameDict allKeys];
    for(NSString *key in keys){
        if([frameDict.dict objectForKey:key]){
            [frameDict.dict removeObjectForKey:key];
        }
        [frameDict.dict setObject:[gridFrameDict objectForKey:key] forKey:key];
    }
    //draw guide line
    for (NSString *IU in selectedIUs){
        [[self gridView] drawGuideLine:[frameDict lineToDrawSamePositionWithIU:IU]];
    }
    
}

#pragma mark updatedText
- (void)updateHTMLText:(NSString *)insertText atIU:(NSString *)iuID{
    
    IULog(@"[IU:%@], %@", iuID, insertText);
}

#pragma mark moveIU
//drag & drop after select IU
- (void)moveDiffPoint:(NSPoint)point{
    for(NSString *IUName in selectedIUs){
        NSRect currentFrame = [[frameDict.dict objectForKey:IUName] rectValue];
        NSRect moveFrame = currentFrame;
        
        moveFrame.origin = NSMakePoint(currentFrame.origin.x+point.x, currentFrame.origin.y+point.y);
        NSPoint guidePoint = [frameDict guidePointOfCurrentFrame:moveFrame IU:IUName];
        moveFrame.origin = guidePoint;
        //TODO: set TO IU
    }
    IULog(@"Point:(%.1f %.1f)", point.x, point.y);
}
//drag pointlayer // only one IU
- (void)changeIUFrame:(NSRect)frame IUID:(NSString *)IUID{
    
    NSRect guideFrame = frame;
    guideFrame.origin = [frameDict guidePointOfCurrentFrame:frame IU:IUID];
    guideFrame.size = [frameDict guideSizeOfCurrentFrame:frame IU:IUID];
    
    //TODO: set TO IU
    IULog(@"[IU:%@]\n origin: (%.1f, %.1f) \n size: (%.1f, %.1f)",
          IUID, guideFrame.origin.x, guideFrame.origin.y, guideFrame.size.width, guideFrame.size.height);
}

//FIXME: inner IU도 표시
- (void)makeNewIU:(NSString *)iuname atPoint:(NSPoint)point atIU:(NSString *)IU{
    IULog(@"[IU:%@] : point(%.1f, %.1f) atIU:%@", iuname, point.x, point.y, IU);
}



@end