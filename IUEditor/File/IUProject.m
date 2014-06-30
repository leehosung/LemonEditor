//
//  IUProject.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUProject.h"
#import "IUPage.h"
#import "IUResourceGroup.h"
#import "IUSheetGroup.h"
#import "IUResourceFile.h"
#import "IUResourceManager.h"
#import "JDUIUtil.h"
#import "IUBackground.h"
#import "IUClass.h"
#import "IUEventVariable.h"
#import "IUResourceManager.h"
#import "IUIdentifierManager.h"

@interface IUProject()

@end

@implementation IUProject{
}

#pragma mark - init
- (void)encodeWithCoder:(NSCoder *)encoder{
    assert(_resourceGroup);
    [encoder encodeObject:_mqSizes forKey:@"mqSizes"];
    [encoder encodeObject:_buildPath forKey:@"_buildPath"];
    [encoder encodeObject:_buildResourcePath forKey:@"_buildResourcePath"];
    [encoder encodeInt32:_compiler.rule forKey:@"_compileRule"];
    [encoder encodeObject:_pageGroup forKey:@"_pageGroup"];
    [encoder encodeObject:_backgroundGroup forKey:@"_backgroundGroup"];
    [encoder encodeObject:_classGroup forKey:@"_classGroup"];
    [encoder encodeObject:_resourceGroup forKey:@"_resourceGroup"];
    [encoder encodeObject:_name forKey:@"_name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _identifierManager = [[IUIdentifierManager alloc] init];
        _compiler = [[IUCompiler alloc] init];
        _resourceManager = [[IUResourceManager alloc] init];
        _compiler.resourceManager = _resourceManager;
        
        _mqSizes = [[aDecoder decodeObjectForKey:@"mqSizes"] mutableCopy];
        _buildPath = [aDecoder decodeObjectForKey:@"_buildPath"];
        _compiler.rule = [aDecoder decodeInt32ForKey:@"_compileRule"];
        _pageGroup = [aDecoder decodeObjectForKey:@"_pageGroup"];
        _backgroundGroup = [aDecoder decodeObjectForKey:@"_backgroundGroup"];
        _classGroup = [aDecoder decodeObjectForKey:@"_classGroup"];
        _resourceGroup = [aDecoder decodeObjectForKey:@"_resourceGroup"];
        _name = [aDecoder decodeObjectForKey:@"_name"];
        _buildResourcePath = [aDecoder decodeObjectForKey:@"_buildResourcePath"];
        
        //version code
        if ([[_pageGroup.name lowercaseString] isEqualToString:@"pages"]){
            _pageGroup.name = IUPageGroupName;
        }
        if ([[_classGroup.name lowercaseString] isEqualToString:@"classes"]) {
            _classGroup.name = IUClassGroupName;
        }
        if ([[_backgroundGroup.name lowercaseString] isEqualToString:@"backgrounds"]) {
            _backgroundGroup.name = IUBackgroundGroupName;
        }
        [_resourceManager setResourceGroup:_resourceGroup];
        [_identifierManager registerIUs:self.allDocuments];
        
        [self connectWithEditor];
    }
    return self;
}
- (id)init{
    self = [super init];
    if(self){
        _buildPath = @"build";
        _mqSizes = [NSMutableArray array];
        _compiler = [[IUCompiler alloc] init];
    }
    return self;
}

-(id)initWithProject:(IUProject*)project options:(NSDictionary*)options error:(NSError**)error{
    self = [super init];
    
    _mqSizes = [NSMutableArray arrayWithArray:@[@(defaultFrameWidth), @700, @400]];
    
    
    _compiler = [[IUCompiler alloc] init];
    _resourceManager = [[IUResourceManager alloc] init];
    _compiler.resourceManager = _resourceManager;
    _identifierManager = [[IUIdentifierManager alloc] init];
    
    assert(options[IUProjectKeyAppName]);
    assert(options[IUProjectKeyProjectPath]);
    
    self.name = [options objectForKey:IUProjectKeyAppName];
    self.path = [options objectForKey:IUProjectKeyProjectPath];
    
    _buildPath = [[options objectForKey:IUProjectKeyBuildPath] relativePathFrom:self.path];
    if (_buildPath == nil) {
        _buildPath = @"build";
    }
    
    _buildResourcePath = [[options objectForKey:IUProjectKeyResourcePath] relativePathFrom:self.path];
    if (_buildResourcePath == nil) {
        _buildResourcePath = @"build/resource";
    }
    
    _pageGroup = [project.pageGroup copy];
    _pageGroup.project = self;
    
    _backgroundGroup = [project.backgroundGroup copy];
    _backgroundGroup.project = self;
    
    _classGroup = [project.classGroup copy];
    _classGroup.project = self;
    
    _resourceGroup = [project.resourceGroup copy];
    _resourceGroup.parent = self;

    [_resourceManager setResourceGroup:_resourceGroup];
    [_identifierManager registerIUs:self.allDocuments];
    
    [self connectWithEditor];
    return self;
}

-(id)initWithCreation:(NSDictionary*)options error:(NSError**)error{
    self = [super init];
    
    _mqSizes = [NSMutableArray arrayWithArray:@[@(defaultFrameWidth), @700, @400]];
    
    
    _compiler = [[IUCompiler alloc] init];
    _resourceManager = [[IUResourceManager alloc] init];
    _compiler.resourceManager = _resourceManager;
    _identifierManager = [[IUIdentifierManager alloc] init];
    
    assert(options[IUProjectKeyAppName]);
    assert(options[IUProjectKeyProjectPath]);
    
    self.name = [options objectForKey:IUProjectKeyAppName];
    self.path = [options objectForKey:IUProjectKeyProjectPath];

    _buildPath = [[options objectForKey:IUProjectKeyBuildPath] relativePathFrom:self.path];
    if (_buildPath == nil) {
        _buildPath = @"build";
    }
    
    _buildResourcePath = [[options objectForKey:IUProjectKeyResourcePath] relativePathFrom:self.path];
    if (_buildResourcePath == nil) {
        _buildResourcePath = @"build/resource";
    }

    _pageGroup = [[IUSheetGroup alloc] init];
    _pageGroup.name = IUPageGroupName;
    _pageGroup.project = self;
    
    _backgroundGroup = [[IUSheetGroup alloc] init];
    _backgroundGroup.name = IUBackgroundGroupName;
    _backgroundGroup.project = self;
    
    _classGroup = [[IUSheetGroup alloc] init];
    _classGroup.name = IUClassGroupName;
    _classGroup.project = self;
    
    IUBackground *bg = [[IUBackground alloc] initWithProject:self options:nil];
    bg.name = @"background";
    bg.htmlID = @"background";
    [self addSheet:bg toSheetGroup:_backgroundGroup];
    
    IUPage *pg = [[IUPage alloc] initWithProject:self options:nil];
    [pg setBackground:bg];
    pg.name = @"index";
    pg.htmlID = @"index";
    [self addSheet:pg toSheetGroup:_pageGroup];
    
    IUClass *class = [[IUClass alloc] initWithProject:self options:nil];
    class.name = @"class";
    class.htmlID = @"class";
    [self addSheet:class toSheetGroup:_classGroup];
    
    [self initializeResource];
    [_resourceManager setResourceGroup:_resourceGroup];
    [_identifierManager registerIUs:self.allDocuments];
    
    //    ReturnNilIfFalse([self save]);
    [self connectWithEditor];
    return self;
}


- (void)connectWithEditor{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMQSize:) name:IUNotificationMQAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMQSize:) name:IUNotificationMQRemoved object:nil];
    
    for (IUSheet *sheet in self.allDocuments) {
        [sheet connectWithEditor];
    }
}

#pragma mark - mq

- (void)addMQSize:(NSNotification *)notification{
    NSInteger size = [[notification.userInfo objectForKey:IUNotificationMQSize] integerValue];
    assert(_mqSizes);
    [_mqSizes addObject:@(size)];
}

- (void)removeMQSize:(NSNotification *)notification{
    NSInteger size = [[notification.userInfo objectForKey:IUNotificationMQSize] integerValue];
    assert(_mqSizes);
    [_mqSizes removeObject:@(size)];
}

- (NSArray*)mqSizes{
    return _mqSizes;
}

#pragma mark - compile
- (IUCompileRule )compileRule{
    return _compiler.rule;
}



- (void)setCompileRule:(IUCompileRule)compileRule{
    _compiler.rule = compileRule;
    assert(_compiler != nil);
}




// return value : project path


+ (id)projectWithContentsOfPath:(NSString*)path{
    IUProject *project = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    project.path = path;
    return project;
}

+ (NSString *)stringProjectType:(IUProjectType)type{
    NSString *projectName ;
    switch (type) {
        case IUProjectTypeDefault:
            projectName = @"IUProject";
            break;
        case IUProjectTypeDjango:
            projectName = @"IUDjangoProject";
            break;
        case IUProjectTypePresentation:
            projectName = @"IUPresentationProject";
        default:
            break;
    }
    return projectName;
}

- (NSString*)directoryPath{
    return [self.path stringByDeletingLastPathComponent];
}

- (NSString*)buildPath{
    return _buildPath;
}

- (NSString*)buildResourcePath{
    return _buildResourcePath;
}

- (BOOL)build:(NSError**)error{
    assert(_buildPath != nil);
    NSString *buildPath = [self.directoryPath stringByAppendingPathComponent:self.buildPath];
    NSString *buildResourcePath = [self.directoryPath stringByAppendingPathComponent:self.buildResourcePath];

    [[NSFileManager defaultManager] removeItemAtPath:buildPath error:error];

    [[NSFileManager defaultManager] createDirectoryAtPath:buildPath withIntermediateDirectories:YES attributes:nil error:error];
    
//    [self initializeResource];
  
    [[NSFileManager defaultManager] copyItemAtPath:_resourceGroup.absolutePath toPath:buildResourcePath error:error];


    IUEventVariable *eventVariable = [[IUEventVariable alloc] init];
    JDCode *initializeJSSource = [[JDCode alloc] init];

    for (IUSheet *doc in self.allDocuments) {
        NSString *outputString = [doc outputSource];
        
        NSString *filePath = [[buildPath stringByAppendingPathComponent:[doc.name lowercaseString]] stringByAppendingPathExtension:@"html"];
        if ([outputString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:error] == NO){
            assert(0);
        }
        
        [eventVariable makeEventDictionary:doc];
        
        [initializeJSSource addCodeLineWithFormat:@"/* Initialize %@ */\n", doc.name];
        [initializeJSSource addCodeLine:[doc outputInitJSSource]];
        [initializeJSSource addNewLine];
    }
    
    NSString *resourceJSPath = [buildResourcePath stringByAppendingPathComponent:@"js"];
    
    //make initialize javascript file
    
    NSString *iuinitFilePath = [[NSBundle mainBundle] pathForResource:@"iuinit" ofType:@"js"];
    
    JDCode *sourceCode = [[JDCode alloc] initWithCodeString: [NSString stringWithContentsOfFile:iuinitFilePath encoding:NSUTF8StringEncoding error:nil]];
    [sourceCode replaceCodeString:@"/*INIT_JS_REPLACEMENT*/" toCode:initializeJSSource];


    NSString *initializeJSPath = [[resourceJSPath stringByAppendingPathComponent:@"iuinit"] stringByAppendingPathExtension:@"js"];
    NSError *myError;
    if ([sourceCode.string writeToFile:initializeJSPath atomically:YES encoding:NSUTF8StringEncoding error:&myError] == NO){
        assert(0);
    }

    
    //make event javascript file
    NSString *eventJSString = [eventVariable outputEventJSSource];
    NSString *eventJSFilePath = [[resourceJSPath stringByAppendingPathComponent:@"iuevent"] stringByAppendingPathExtension:@"js"];
    if ([eventJSString writeToFile:eventJSFilePath atomically:YES encoding:NSUTF8StringEncoding error:error] == NO){
        assert(0);
    }
    
    [JDUIUtil hudAlert:@"Build Success" second:2];
    return YES;
}



-(BOOL)save{
    return [NSKeyedArchiver archiveRootObject:self toFile:_path];
}


- (void)addImageResource:(NSImage*)image{
    assert(0);
}

-(NSArray*)allIUs{
    NSMutableArray  *array = [NSMutableArray array];
    for (IUSheet *sheet in self.allDocuments) {
        [array addObject:sheet];
        [array addObjectsFromArray:sheet.allChildren];
    }
    return array;
}

- (NSArray *)childrenFiles{
    return @[_pageGroup, _backgroundGroup, _classGroup, _resourceGroup];
}

- (IUResourceGroup*)resourceNode{
    return [self.childrenFiles objectAtIndex:3];
}

- (IUCompiler*)compiler{
    return _compiler;
}

- (void)initializeResource{
    //remove resource node if exist
    JDInfoLog(@"initilizeResource");
    
    _resourceGroup = [[IUResourceGroup alloc] init];
    _resourceGroup.name = IUResourceGroupName;
    _resourceGroup.parent = self;
    
    
    IUResourceGroup *imageGroup = [[IUResourceGroup alloc] init];
    imageGroup.name = IUImageResourceGroupName;
    [_resourceGroup addResourceGroup:imageGroup];
    
    IUResourceGroup *videoGroup = [[IUResourceGroup alloc] init];
    videoGroup.name = IUVideoResourceGroupName;
    [_resourceGroup addResourceGroup:videoGroup];
    
    IUResourceGroup *JSGroup = [[IUResourceGroup alloc] init];
    JSGroup.name = IUJSResourceGroupName;
    [_resourceGroup addResourceGroup:JSGroup];
    
    IUResourceGroup *CSSGroup = [[IUResourceGroup alloc] init];
    CSSGroup.name = IUCSSResourceGroupName;
    [_resourceGroup addResourceGroup:CSSGroup];
    
    
    //images resource copy
    NSString *sampleImgPath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"jpg"];
    [imageGroup addResourceFileWithContentOfPath:sampleImgPath];
    
    NSString *carouselImagePath = [[NSBundle mainBundle] pathForResource:@"bx_loader" ofType:@"gif"];
    [imageGroup addResourceFileWithContentOfPath:carouselImagePath];
    
    NSString *carouselImagePath2 = [[NSBundle mainBundle] pathForResource:@"controls" ofType:@"png"];
    [imageGroup addResourceFileWithContentOfPath:carouselImagePath2];
    
    NSString *sampleVideoPath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    [videoGroup addResourceFileWithContentOfPath:sampleVideoPath];
    
    //CSS resource Copy
    NSString *resetCSSPath = [[NSBundle mainBundle] pathForResource:@"reset" ofType:@"css"];
    [CSSGroup addResourceFileWithContentOfPath:resetCSSPath];
    
    NSString *iuCSSPath = [[NSBundle mainBundle] pathForResource:@"iu" ofType:@"css"];
    [CSSGroup addResourceFileWithContentOfPath:iuCSSPath];
    
    NSString *carouselCSSPath = [[NSBundle mainBundle] pathForResource:@"jquery.bxslider" ofType:@"css"];
    [CSSGroup addResourceFileWithContentOfPath:carouselCSSPath];
    
    //Java Script resource copy
    NSString *iuEditorJSPath = [[NSBundle mainBundle] pathForResource:@"iueditor" ofType:@"js"];
    [JSGroup addResourceFileWithContentOfPath:iuEditorJSPath];

    NSString *iuFrameJSPath = [[NSBundle mainBundle] pathForResource:@"iuframe" ofType:@"js"];
    [JSGroup addResourceFileWithContentOfPath:iuFrameJSPath];
    
    NSString *iuJSPath = [[NSBundle mainBundle] pathForResource:@"iu" ofType:@"js"];
    [JSGroup addResourceFileWithContentOfPath:iuJSPath];
    
    NSString *bxsliderJSPath = [[NSBundle mainBundle] pathForResource:@"jquery.bxslider" ofType:@"js"];
    [JSGroup addResourceFileWithContentOfPath:bxsliderJSPath];
    
    NSString *ieJSPath = [[NSBundle mainBundle] pathForResource:@"jquery.backgroundSize" ofType:@"js"];
    [JSGroup addResourceFileWithContentOfPath:ieJSPath];
}


-(void)copyResourceForDebug{
    /*
    IUResourceGroup *JSGroup;
    IUResourceGroup *CSSGroup;

    for(IUResourceGroup *groupNode in self.resourceNode.children){
        if([groupNode.name isEqualToString:@"JS"]){
            JSGroup = groupNode;
        }
        if([groupNode.name isEqualToString:@"CSS"]){
            CSSGroup = groupNode;
        }
    }

    //Java Script resource copy
    NSString *iuEditorJSPath = [[NSBundle mainBundle] pathForResource:@"iueditor" ofType:@"js"];
    [self copyFile:iuEditorJSPath toPath:[JSGroup.absolutePath stringByAppendingPathComponent:@"iueditor.js"]];

    NSString *iuFrameJSPath = [[NSBundle mainBundle] pathForResource:@"iuframe" ofType:@"js"];
    [self copyFile:iuFrameJSPath toPath:[JSGroup.absolutePath stringByAppendingPathComponent:@"iuframe.js"]];
    
    NSString *iuJSPath = [[NSBundle mainBundle] pathForResource:@"iu" ofType:@"js"];
    [self copyFile:iuJSPath toPath:[JSGroup.absolutePath stringByAppendingPathComponent:@"iu.js"]];
    
    NSString *carouselJSPath = [[NSBundle mainBundle] pathForResource:@"jquery.bxslider" ofType:@"js"];
    [self copyFile:carouselJSPath toPath:[JSGroup.absolutePath stringByAppendingPathComponent:@"jquery.bxslider.js"]];

    //css resource copy
    NSString *IUCSSPath = [[NSBundle mainBundle] pathForResource:@"iu" ofType:@"css"];
    [self copyFile:IUCSSPath toPath:[CSSGroup.absolutePath stringByAppendingPathComponent:@"iu.css"]];

    NSString *resetCSSPath = [[NSBundle mainBundle] pathForResource:@"reset" ofType:@"css"];
    [self copyFile:resetCSSPath toPath:[CSSGroup.absolutePath stringByAppendingPathComponent:@"reset.css"]];
    
    NSString *carouselCSSPath = [[NSBundle mainBundle] pathForResource:@"jquery.bxslider" ofType:@"css"];
    [self copyFile:carouselCSSPath toPath:[CSSGroup.absolutePath stringByAppendingPathComponent:@"jquery.bxslider.css"]];

     */
}

-(void)dealloc{
    JDInfoLog(@"Project Dealloc");
}

- (NSArray*)allDocuments{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.pageDocuments];
    [array addObjectsFromArray:self.backgroundDocuments];
    [array addObjectsFromArray:self.classDocuments];
    return array;
}
- (NSArray*)pageDocuments{
    assert(_pageGroup);
    return _pageGroup.childrenFiles;
}
- (NSArray*)backgroundDocuments{
    return _backgroundGroup.childrenFiles;
}
- (NSArray*)classDocuments{
    return _classGroup.childrenFiles;
}

- (BOOL)runnable{
    return NO;
}

- (IUIdentifierManager*)identifierManager{
    return _identifierManager;
}

- (IUResourceManager *)resourceManager{
    return _resourceManager;
}

- (id)parent{
    return nil;
}

- (IUSheetGroup*)pageGroup{
    return _pageGroup;
}
- (IUSheetGroup*)backgroundGroup{
    return _backgroundGroup;
}
- (IUSheetGroup*)classGroup{
    return _classGroup;
}
- (IUResourceGroup*)resourceGroup{
    return _resourceGroup;
}

- (void)addSheet:(IUSheet *)sheet toSheetGroup:(IUSheetGroup *)sheetGroup{
    if([sheetGroup isEqualTo:_pageGroup]){
        [self willChangeValueForKey:@"pageGroup"];
        [self willChangeValueForKey:@"pageDocuments"];

    }
    else if([sheetGroup isEqualTo:_backgroundGroup]){
        [self willChangeValueForKey:@"backgroundGroup"];
        [self willChangeValueForKey:@"backgroundDocuments"];

    }
    else if([sheetGroup isEqualTo:_classGroup]){
        [self willChangeValueForKey:@"classGroup"];
        [self willChangeValueForKey:@"classDocuments"];

    }
    
    [sheetGroup addSheet:sheet];
    
    if([sheetGroup isEqualTo:_pageGroup]){
        [self didChangeValueForKey:@"pageGroup"];
        [self didChangeValueForKey:@"pageDocuments"];

    }
    else if([sheetGroup isEqualTo:_backgroundGroup]){
        [self didChangeValueForKey:@"backgroundGroup"];
        [self didChangeValueForKey:@"backgroundDocuments"];

    }
    else if([sheetGroup isEqualTo:_classGroup]){
        [self didChangeValueForKey:@"classGroup"];
        [self didChangeValueForKey:@"classDocuments"];

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationStructureDidChange object:self userInfo:@{IUNotificationStructureChangeType: IUNotificationStructureAdding, IUNotificationStructureChangedIU: sheet}];
}

- (void)removeSheet:(IUSheet *)sheet toSheetGroup:(IUSheetGroup *)sheetGroup{
    if([sheetGroup isEqualTo:_pageGroup]){
        [self willChangeValueForKey:@"pageGroup"];
        [self willChangeValueForKey:@"pageDocuments"];
        
    }
    else if([sheetGroup isEqualTo:_backgroundGroup]){
        [self willChangeValueForKey:@"backgroundGroup"];
        [self willChangeValueForKey:@"backgroundDocuments"];
        
    }
    else if([sheetGroup isEqualTo:_classGroup]){
        [self willChangeValueForKey:@"classGroup"];
        [self willChangeValueForKey:@"classDocuments"];
        
    }
    [sheetGroup removeSheet:sheet];
    
    if([sheetGroup isEqualTo:_pageGroup]){
        [self didChangeValueForKey:@"pageGroup"];
        [self didChangeValueForKey:@"pageDocuments"];
        
    }
    else if([sheetGroup isEqualTo:_backgroundGroup]){
        [self didChangeValueForKey:@"backgroundGroup"];
        [self didChangeValueForKey:@"backgroundDocuments"];
        
    }
    else if([sheetGroup isEqualTo:_classGroup]){
        [self didChangeValueForKey:@"classGroup"];
        [self didChangeValueForKey:@"classDocuments"];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationStructureDidChange object:self userInfo:@{IUNotificationStructureChangeType: IUNotificationStructureChangeRemoving, IUNotificationStructureChangedIU: sheet}];
}

@end