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
#import "IUDocumentGroup.h"
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
    IUCompiler *_compiler;
    IUResourceManager *_resourceManager;
    IUIdentifierManager *_identifierManager;
    NSString  *_path;
}


- (void)encodeWithCoder:(NSCoder *)encoder{
    assert(_resourceGroup);
    [encoder encodeObject:_mqSizes forKey:@"mqSizes"];
    [encoder encodeObject:_buildPath forKey:@"_buildPath"];
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
        _compiler.resourceSource = _resourceManager;
        
        _mqSizes = [[aDecoder decodeObjectForKey:@"mqSizes"] mutableCopy];
        _buildPath = [aDecoder decodeObjectForKey:@"_buildPath"];
        _compiler.rule = [aDecoder decodeInt32ForKey:@"_compileRule"];
        _pageGroup = [aDecoder decodeObjectForKey:@"_pageGroup"];
        _backgroundGroup = [aDecoder decodeObjectForKey:@"_backgroundGroup"];
        _classGroup = [aDecoder decodeObjectForKey:@"_classGroup"];
        _resourceGroup = [aDecoder decodeObjectForKey:@"_resourceGroup"];
        _name = [aDecoder decodeObjectForKey:@"_name"];
        
        [_resourceManager setResourceGroup:_resourceGroup];
    }
    return self;
}

- (IUCompileRule )compileRule{
    return _compiler.rule;
}

- (void)setCompileRule:(IUCompileRule)compileRule{
    _compiler.rule = compileRule;
    assert(_compiler != nil);
}

- (id)init{
    self = [super init];
    if(self){
        _buildPath = @"build";
        _mqSizes = [NSMutableArray array];
        _compiler = [[IUCompiler alloc] init];
        [_mqSizes addObject:@(defaultFrameWidth)];
        [_mqSizes addObject:@(700)];
        [_mqSizes addObject:@(400)];
    }
    return self;
}


// return value : project path
-(id)initWithCreation:(NSDictionary*)options error:(NSError**)error{
    self = [super init];
    assert(options[IUProjectKeyAppName]);
    assert(options[IUProjectKeyDirectory]);
    
    _mqSizes = [NSMutableArray arrayWithArray:@[@(defaultFrameWidth), @700, @400]];
    _buildPath = @"build";
    _compiler = [[IUCompiler alloc] init];
    _resourceManager = [[IUResourceManager alloc] init];
    _compiler.resourceSource = _resourceManager;
    _identifierManager = [[IUIdentifierManager alloc] init];
    
    self.name = [options objectForKey:IUProjectKeyAppName];
    NSString *fileName = [options[IUProjectKeyAppName] stringByAppendingPathExtension:@"iu"];
    NSString *projectDir = [options[IUProjectKeyDirectory] stringByAppendingPathComponent:options[IUProjectKeyAppName]];
    self.path = [projectDir stringByAppendingPathComponent:fileName];
    
    _buildPath = @"build";
    NSError *err;
    [[NSFileManager defaultManager] createDirectoryAtPath:projectDir withIntermediateDirectories:YES attributes:nil error:&err];
    if (err) {
        [JDLogUtil log:@"mkdir" err:err];
    }
    _pageGroup = [[IUDocumentGroup alloc] init];
    _pageGroup.name = @"Pages";
    _pageGroup.project = self;
    
    _backgroundGroup = [[IUDocumentGroup alloc] init];
    _backgroundGroup.name = @"Backgrounds";
    _backgroundGroup.project = self;
    
    _classGroup = [[IUDocumentGroup alloc] init];
    _classGroup.name = @"Classes";
    _classGroup.project = self;

    IUBackground *bg = [[IUBackground alloc] initWithProject:self options:nil];
    bg.name = @"background";
    bg.htmlID = @"background";
    [_backgroundGroup addDocument:bg];

    IUPage *pg = [[IUPage alloc] initWithProject:self options:nil];
    [pg setBackground:bg];
    pg.name = @"index";
    pg.htmlID = @"index";
    [_pageGroup addDocument:pg];
    
    IUClass *class = [[IUClass alloc] initWithProject:self options:nil];
    class.name = @"class";
    class.htmlID = @"class";
    [_classGroup addDocument:class];
    
    [self initializeResource];
    ReturnNilIfFalse([self save]);
    return self;
}


+ (id)projectWithContentsOfPath:(NSString*)path{
    IUProject *project = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    project.path = path;
    return project;
}

-(NSString*)path{
    return _path;
}

- (void)setPath:(NSString *)path{
    _path = [path copy];
}

- (NSString*)directory{
    return [self.path stringByDeletingLastPathComponent];
}

- (NSString*)buildPath{
    return _buildPath;
}

- (BOOL)build:(NSError**)error{
    assert(_buildPath != nil);
    NSString *buildPath = [self.directory stringByAppendingPathComponent:self.buildPath];

    [[NSFileManager defaultManager] removeItemAtPath:buildPath error:error];

    [[NSFileManager defaultManager] createDirectoryAtPath:buildPath withIntermediateDirectories:YES attributes:nil error:error];
    
//    [self initializeResource];
    
    [[NSFileManager defaultManager] createSymbolicLinkAtPath:[buildPath stringByAppendingPathComponent:@"Resource"] withDestinationPath:[@".." stringByAppendingPathComponent:@"Resource"] error:error];


    IUEventVariable *eventVariable = [[IUEventVariable alloc] init];
    NSMutableString *initializeJSSource = [NSMutableString string];

    for (IUDocument *doc in self.allDocuments) {
        NSString *outputString = [doc outputSource];
        
        NSString *filePath = [[buildPath stringByAppendingPathComponent:[doc.name lowercaseString]] stringByAppendingPathExtension:@"html"];
        if ([outputString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:error] == NO){
            assert(0);
        }
        
        [eventVariable makeEventDictionary:doc];
        
        [initializeJSSource appendFormat:@"/* Initialize %@ */\n", doc.name];
        [initializeJSSource appendString:[doc outputInitJSSource]];
        [initializeJSSource appendNewline];
    }
    
    NSString *resourceJSPath = [self.directory stringByAppendingPathComponent:@"Resource/JS"];
    
    //make initialize javascript file
    [initializeJSSource insertString:@"$(document).ready(function(){\nconsole.log('ready : iuinit.js');" atIndex:0];
    [initializeJSSource appendString:@"\n});"];
    NSString *initializeJSPath = [[resourceJSPath stringByAppendingPathComponent:@"iuinit"] stringByAppendingPathExtension:@"js"];
    if ([initializeJSSource writeToFile:initializeJSPath atomically:YES encoding:NSUTF8StringEncoding error:error] == NO){
        assert(0);
    }

    
    //make event javascript file
    NSString *eventJSString = [eventVariable outputEventJSSource];
    NSString *eventJSFilePath = [[resourceJSPath stringByAppendingPathComponent:@"iuevent"] stringByAppendingPathExtension:@"js"];
    if ([eventJSString writeToFile:eventJSFilePath atomically:YES encoding:NSUTF8StringEncoding error:error] == NO){
        assert(0);
    }
    
    
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
    for (IUDocument *document in self.allDocuments) {
        [array addObject:document];
        [array addObjectsFromArray:document.allChildren];
    }
    return array;
}

- (NSArray *)children{
    return @[_pageGroup, _backgroundGroup, _classGroup, _resourceGroup];
}

- (IUResourceGroup*)resourceNode{
    return [self.children objectAtIndex:3];
}

- (IUCompiler*)compiler{
    return _compiler;
}

- (void)initializeResource{
    //remove resource node if exist
    JDInfoLog(@"initilizeResource");
    
    _resourceGroup = [[IUResourceGroup alloc] init];
    _resourceGroup.name = @"Resource";
    _resourceGroup.parent = self;
    
    IUResourceGroup *imageGroup = [_resourceGroup addResourceGroupWithName:@"Image"];
    IUResourceGroup *videoGroup = [_resourceGroup addResourceGroupWithName:@"Video"];
    IUResourceGroup *JSGroup = [_resourceGroup addResourceGroupWithName:@"JS"];
    IUResourceGroup *CSSGroup = [_resourceGroup addResourceGroupWithName:@"CSS"];
    
    //Image Resource copy
    NSString *sampleImgPath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"jpg"];
    [imageGroup addResourceFileWithContentOfPath:sampleImgPath];
    
    NSString *carouselImagePath = [[NSBundle mainBundle] pathForResource:@"bx_loader" ofType:@"gif"];
    [imageGroup addResourceFileWithContentOfPath:carouselImagePath];
    
    NSString *carouselImagePath2 = [[NSBundle mainBundle] pathForResource:@"controls" ofType:@"png"];
    [imageGroup addResourceFileWithContentOfPath:carouselImagePath2];
    
    NSString *sampleVideoPath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    [videoGroup addResourceFileWithContentOfPath:sampleVideoPath];
    
    //CSS Resource Copy
    NSString *resetCSSPath = [[NSBundle mainBundle] pathForResource:@"reset" ofType:@"css"];
    [CSSGroup addResourceFileWithContentOfPath:resetCSSPath];
    
    NSString *iuCSSPath = [[NSBundle mainBundle] pathForResource:@"iu" ofType:@"css"];
    [CSSGroup addResourceFileWithContentOfPath:iuCSSPath];
    
    NSString *carouselCSSPath = [[NSBundle mainBundle] pathForResource:@"jquery.bxslider" ofType:@"css"];
    [CSSGroup addResourceFileWithContentOfPath:carouselCSSPath];
    
    //Java Script Resource copy
    NSString *iuEditorJSPath = [[NSBundle mainBundle] pathForResource:@"iueditor" ofType:@"js"];
    [JSGroup addResourceFileWithContentOfPath:iuEditorJSPath];

    NSString *iuFrameJSPath = [[NSBundle mainBundle] pathForResource:@"iuframe" ofType:@"js"];
    [JSGroup addResourceFileWithContentOfPath:iuFrameJSPath];
    
    NSString *iuJSPath = [[NSBundle mainBundle] pathForResource:@"iu" ofType:@"js"];
    [JSGroup addResourceFileWithContentOfPath:iuJSPath];
    
    NSString *bxsliderJSPath = [[NSBundle mainBundle] pathForResource:@"jquery.bxslider" ofType:@"js"];
    [JSGroup addResourceFileWithContentOfPath:bxsliderJSPath];
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

    //Java Script Resource copy
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
    return _pageGroup.children;
}
- (NSArray*)backgroundDocuments{
    return _backgroundGroup.children;
}
- (NSArray*)classDocuments{
    return _classGroup.children;
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

@end