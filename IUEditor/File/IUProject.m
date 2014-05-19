//
//  IUProject.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUProject.h"
#import "IUPage.h"
#import "IUDocumentGroupNode.h"
#import "IUResourceGroupNode.h"
#import "IUDocumentNode.h"
#import "IUResourceNode.h"
#import "JDUIUtil.h"
#import "IUBackground.h"
#import "IUClass.h"
#import "IUEventVariable.h"

@interface IUProject()

@end

@implementation IUProject{
}


- (void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:_herokuOn forKey:@"herokuOn"];
    [encoder encodeInt32:_gitType forKey:@"gitType"];
    [encoder encodeObject:_resourceNode forKey:@"_resourceNode"];
    [encoder encodeObject:_pageDocumentGroup forKey:@"_pageDocumentGroup"];
    [encoder encodeObject:_backgroundDocumentGroup forKey:@"_backgroundDocumentGroup"];
    [encoder encodeObject:_classDocumentGroup forKey:@"_classDocumentGroup"];
    [encoder encodeObject:_mqSizes forKey:@"mqSizes"];
    [encoder encodeObject:_buildDirectoryName forKey:@"_buildDirectoryName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _herokuOn = [aDecoder decodeBoolForKey:@"herokuOn"];
        _gitType = [aDecoder decodeInt32ForKey:@"gitType"];
        _resourceNode = [aDecoder decodeObjectForKey:@"_resourceNode"];
        _pageDocumentGroup = [aDecoder decodeObjectForKey:@"_pageDocumentGroup"];
        _backgroundDocumentGroup = [aDecoder decodeObjectForKey:@"_backgroundDocumentGroup"];
        _classDocumentGroup = [aDecoder decodeObjectForKey:@"_classDocumentGroup"];
        _buildDirectoryName = [aDecoder decodeObjectForKey:@"_buildDirectoryName"];
        _mqSizes = [[aDecoder decodeObjectForKey:@"mqSizes"] mutableCopy];
        if ([_buildDirectoryName isEqualToString:@"../template/"]) {
            _buildDirectoryName = @"../templates/";\
        }
    }
    return self;
}

- (id)init{
    self = [super init];
    if(self){
        _buildDirectoryName = @"build";
        _mqSizes = [NSMutableArray array];
        [_mqSizes addObject:@(defaultFrameWidth)];
        [_mqSizes addObject:@(700)];
        [_mqSizes addObject:@(400)];
    }
    return self;
}

- (NSString*)relativePath{
    return @".";
}
- (NSString*)absolutePath{
    return _path;
}

// return value : project path
+(IUProject*)createProject:(NSDictionary*)setting error:(NSError**)error{

    IUProject *project = [[self alloc] init];
    project.name = [setting objectForKey:IUProjectKeyAppName];
    project.buildDirectoryName = @"build";
    
    NSString *dir = [setting objectForKey:IUProjectKeyDirectory];
    project.path = [dir stringByAppendingPathComponent:[project.name stringByAppendingPathExtension:@"iuproject"]];
    [JDFileUtil rmDirPath:[project.path stringByAppendingPathExtension:@"*"]];
    ReturnNilIfFalse([JDFileUtil mkdirPath:project.path]);
    
    //create document dir
    
    IUDocumentGroupNode *pageDir = [[IUDocumentGroupNode alloc] init];
    pageDir.name = @"Pages";
    [project addNode:pageDir];
    project.pageDocumentGroup = pageDir;
    
    IUDocumentGroupNode *backgroundGroup = [[IUDocumentGroupNode alloc] init];
    backgroundGroup.name = @"Backgrounds";
    [project addNode:backgroundGroup];
    project.backgroundDocumentGroup = backgroundGroup;
    
    IUDocumentGroupNode *classGroup = [[IUDocumentGroupNode alloc] init];
    classGroup.name = @"Classes";
    [project addNode:classGroup];
    project.classDocumentGroup = backgroundGroup;

    //create document
    IUPage *page = [[IUPage alloc] initWithIdentifierManager:nil option:nil];
    page.htmlID = @"Page1Index";
    
    IUDocumentNode *pageNode = [[IUDocumentNode alloc] init];
    pageNode.document = page;
    pageNode.name = @"Index";
    [pageDir addNode:pageNode];
    
    IUBackground *background = [[IUBackground alloc] initWithIdentifierManager:nil option:nil];
    background.htmlID = @"Background1";
    background.name = @"Background1";
    page.background = background;
    
    IUDocumentNode *backgroundNode = [[IUDocumentNode alloc] init];
    backgroundNode.document = background;
    backgroundNode.name = @"Background1";
    [backgroundGroup addNode:backgroundNode];
    
    IUClass *class = [[IUClass alloc] initWithIdentifierManager:nil option:nil];
    class.htmlID = @"Class1";
    class.name = @"Class1";
    
    IUDocumentNode *classNode = [[IUDocumentNode alloc] init];
    classNode.document = class;
    classNode.name = @"Class1";
    [classGroup addNode:classNode];

    IUClass *class2 = [[IUClass alloc] initWithIdentifierManager:nil option:nil];
    class2.htmlID = @"Class2";
    class2.name = @"Class2";
    
    IUDocumentNode *classNode2 = [[IUDocumentNode alloc] init];
    classNode2.document = class2;
    classNode2.name = @"Class2";
    [classGroup addNode:classNode2];

    
    [project initializeResource];
    ReturnNilIfFalse([project save]);
    return project;
}


+ (id)projectWithContentsOfPackage:(NSString*)path{
    IUProject *project = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"IUML"]];
    project.path = path;
    return project;
}

-(NSString*)path{
    return _path;
}

-(NSString*)IUMLPath{
    return [_path stringByAppendingPathComponent:@"IUML"];
}

-(void)addResourceGroupNode:(IUResourceNode*)node{
    [super addNode:node];
    [[NSFileManager defaultManager] createDirectoryAtPath:node.absolutePath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (BOOL)build:(NSError**)error{
    assert(_buildDirectoryName != nil);
    NSString *buildPath = [self.path stringByAppendingPathComponent:self.buildDirectoryName];

    [[NSFileManager defaultManager] removeItemAtPath:buildPath error:error];

    [[NSFileManager defaultManager] createDirectoryAtPath:buildPath withIntermediateDirectories:YES attributes:nil error:error];
    
//    [self initializeResource];
    [[NSFileManager defaultManager] createSymbolicLinkAtPath:[buildPath stringByAppendingPathComponent:@"Resource"] withDestinationPath:[self.path stringByAppendingPathComponent:@"Resource"] error:error];


    IUEventVariable *eventVariable = [[IUEventVariable alloc] init];
    NSMutableString *initializeJSSource = [NSMutableString string];

    for (IUDocumentNode *node in self.allDocumentNodes) {
        NSString *outputString = [node.document outputSource];
        
        NSString *filePath = [[buildPath stringByAppendingPathComponent:node.name] stringByAppendingPathExtension:@"html"];
        if ([outputString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:error] == NO){
            assert(0);
        }
        
        [eventVariable makeEventDictionary:node.document];
        
        [initializeJSSource appendFormat:@"/* Initialize %@ */\n", node.name];
        [initializeJSSource appendString:[node.document outputInitJSSource]];
        [initializeJSSource appendNewline];
    }
    
    NSString *resourceJSPath = [[self.path stringByAppendingPathComponent:@"Resource"] stringByAppendingPathComponent:@"JS"];
    
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
    return [NSKeyedArchiver archiveRootObject:self toFile:[self IUMLPath]];
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

- (NSArray*)pageDocuments{
    return [_pageDocumentGroup allDocuments];
}

- (NSArray*)backgroundDocuments{
    return [_backgroundDocumentGroup allDocuments];
}

- (NSArray*)classDocuments{
    return [_classDocumentGroup allDocuments];
}

- (IUResourceGroupNode*)resourceNode{
    return _resourceNode;
}


- (void)initializeResource{
    //remove resource node if exist
    JDInfoLog(@"initilizeResource");
    [self removeNode:_resourceNode];
    
    IUResourceGroupNode *rootNode = [[IUResourceGroupNode alloc] init];
    rootNode.name = @"Resource";
    [self addResourceGroupNode:rootNode];
    _resourceNode = rootNode;
    
    IUResourceGroupNode *imageGroup = [[IUResourceGroupNode alloc] init];
    imageGroup.name = @"Image";
    [rootNode addResourceGroupNode:imageGroup];
    
    IUResourceGroupNode *videoGroup = [[IUResourceGroupNode alloc] init];
    videoGroup.name = @"Video";
    [rootNode addResourceGroupNode:videoGroup];
    
    
    IUResourceGroupNode *CSSGroup = [[IUResourceGroupNode alloc] init];
    CSSGroup.name = @"CSS";
    [rootNode addResourceGroupNode:CSSGroup];
    
    IUResourceGroupNode *JSGroup = [[IUResourceGroupNode alloc] init];
    JSGroup.name = @"JS";
    [rootNode addResourceGroupNode:JSGroup];
    
    
    //Image Resource copy
    
    NSString *sampleImgPath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"jpg"];
    IUResourceNode *imageNode = [[IUResourceNode alloc] initWithName:@"sample.jpg" type:IUResourceTypeImage];
    [imageGroup addResourceNode:imageNode path:sampleImgPath];
    
    NSString *carouselImagePath = [[NSBundle mainBundle] pathForResource:@"bx_loader" ofType:@"gif"];
    IUResourceNode *carouselImageNode = [[IUResourceNode alloc] initWithName:@"bx_loader.gif" type:IUResourceTypeImage];
    [imageGroup addResourceNode:carouselImageNode path:carouselImagePath];
    
    NSString *carouselImagePath2 = [[NSBundle mainBundle] pathForResource:@"controls" ofType:@"png"];
    IUResourceNode *carouselImageNode2 = [[IUResourceNode alloc] initWithName:@"controls.png" type:IUResourceTypeImage];
    [imageGroup addResourceNode:carouselImageNode2 path:carouselImagePath2];
    
    //Video Resource copy
    NSString *sampleVideoPath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    IUResourceNode *videoNode = [[IUResourceNode alloc] initWithName:@"movie.mp4" type:IUResourceTypeVideo];
    [videoGroup addResourceNode:videoNode path:sampleVideoPath];
    
    
    //CSS Resource Copy
    
    NSString *resetCSSPath = [[NSBundle mainBundle] pathForResource:@"reset" ofType:@"css"];
    IUResourceNode *resetCSSNode = [[IUResourceNode alloc] initWithName:@"reset.css" type:IUResourceTypeCSS];
    [CSSGroup addResourceNode:resetCSSNode path:resetCSSPath];
    
    NSString *iuCSSPath = [[NSBundle mainBundle] pathForResource:@"iu" ofType:@"css"];
    IUResourceNode *iuCSSNode = [[IUResourceNode alloc] initWithName:@"iu.css" type:IUResourceTypeCSS];
    [CSSGroup addResourceNode:iuCSSNode path:iuCSSPath];
    
    NSString *carouselCSSPath = [[NSBundle mainBundle] pathForResource:@"jquery.bxslider" ofType:@"css"];
    IUResourceNode *carouselCSSNode = [[IUResourceNode alloc] initWithName:@"jquery.bxslider.css" type:IUResourceTypeCSS];
    [CSSGroup addResourceNode:carouselCSSNode path:carouselCSSPath];
    
    
    //Java Script Resource copy
    
    NSString *iuEditorJSPath = [[NSBundle mainBundle] pathForResource:@"iueditor" ofType:@"js"];
    IUResourceNode *iuEditorJSNode = [[IUResourceNode alloc] initWithName:@"iueditor.js" type:IUResourceTypeJS];
    [JSGroup addResourceNode:iuEditorJSNode path:iuEditorJSPath];
    
    NSString *iuFrameJSPath = [[NSBundle mainBundle] pathForResource:@"iuframe" ofType:@"js"];
    IUResourceNode *iuFrameJSNode = [[IUResourceNode alloc] initWithName:@"iuframe.js" type:IUResourceTypeJS];
    [JSGroup addResourceNode:iuFrameJSNode path:iuFrameJSPath];
    
    NSString *iuJSPath = [[NSBundle mainBundle] pathForResource:@"iu" ofType:@"js"];
    IUResourceNode *iuJSNode = [[IUResourceNode alloc] initWithName:@"iu.js" type:IUResourceTypeJS];
    [JSGroup addResourceNode:iuJSNode path:iuJSPath];
    
    NSString *carouselJSPath = [[NSBundle mainBundle] pathForResource:@"jquery.bxslider" ofType:@"js"];
    IUResourceNode *carouselJSNode = [[IUResourceNode alloc] initWithName:@"jquery.bxslider.js" type:IUResourceTypeJS];
    [JSGroup addResourceNode:carouselJSNode path:carouselJSPath];


}

-(void)copyFile:(NSString *)path toPath:(NSString *)toPath{

    if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
    }
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:nil];
}



-(void)copyResourceForDebug{
    IUResourceGroupNode *JSGroup;
    IUResourceGroupNode *CSSGroup;

    for(IUResourceGroupNode *groupNode in self.resourceNode.children){
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


}

- (NSArray*)allDocumentNodes{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUDocumentNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[IUDocumentNode class]]) {
            return YES;
        }
        return NO;
    }];
    return [self.allChildren filteredArrayUsingPredicate:predicate];
}

- (NSArray*)pageDocumentNodes{
    NSArray *allDocumentNodes = self.allDocumentNodes;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUDocumentNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject.document isKindOfClass:[IUPage class]]) {
            return YES;
        }
        return NO;
    }];
    return [allDocumentNodes filteredArrayUsingPredicate:predicate];
}

- (NSArray*)backgroundDocumentNodes{
    NSArray *allDocumentNodes = self.allDocumentNodes;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUDocumentNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject.document isKindOfClass:[IUBackground class]]) {
            return YES;
        }
        return NO;
    }];
    return [allDocumentNodes filteredArrayUsingPredicate:predicate];
}

- (NSArray*)classDocumentNodes{
    NSArray *allDocumentNodes = self.allDocumentNodes;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUDocumentNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject.document isKindOfClass:[IUClass class]]) {
            return YES;
        }
        return NO;
    }];
    return [allDocumentNodes filteredArrayUsingPredicate:predicate];
}

-(void)dealloc{
    JDInfoLog(@"Project Dealloc");
}

@end