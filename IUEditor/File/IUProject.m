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
#import "IUCompiler.h"
#import "IUDocumentNode.h"
#import "IUResourceNode.h"
#import "JDUIUtil.h"
#import "IUMaster.h"

@interface IUProject()
@property (nonatomic, copy) NSString          *path;
@property IUDocumentGroupNode *pageDocumentGroup;
@property IUDocumentGroupNode *masterDocumentGroup;
@property IUDocumentGroupNode *componentDocumentGroup;
@end

@implementation IUProject{
    NSMutableDictionary *IDDict;
    NSMutableArray  *_imageNames;
    NSMutableDictionary *_resourcePaths;
}


- (void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:_herokuOn forKey:@"herokuOn"];
    [encoder encodeInt32:_gitType forKey:@"gitType"];
    [encoder encodeObject:_path forKey:@"path"];
    [encoder encodeObject:IDDict forKey:@"IDDict"];
    [encoder encodeObject:_imageNames forKey:@"imageNames"];
    [encoder encodeObject:_resourcePaths forKey:@"resourcePaths"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _compiler = [[IUCompiler alloc] init];
        _resourcePaths = [[aDecoder decodeObjectForKey:@"resourcePaths"] mutableCopy];

        [_compiler bind:@"resourcePaths" toObject:self withKeyPath:@"resourcePaths" options:nil];
        _herokuOn = [aDecoder decodeBoolForKey:@"herokuOn"];
        _gitType = [aDecoder decodeInt32ForKey:@"gitType"];
        _path = [aDecoder decodeObjectForKey:@"path"];
        IDDict = [aDecoder decodeObjectForKey:@"IDDict"];
        _imageNames = [[aDecoder decodeObjectForKey:@"imageNames"] mutableCopy];
    }
    return self;
}

- (id)init{
    self = [super init];
    if(self){
        IDDict = [NSMutableDictionary dictionary];
        _imageNames = [NSMutableArray array];
        _resourcePaths = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSString*)requestNewID:(Class)class{
    int i=0;
    NSArray *allIUs = self.allIUs;
    
    NSString    *newName;
    while (1) {
        i++;
        newName = [NSString stringWithFormat:@"%@%d",[NSStringFromClass(class) substringFromIndex:2], i];
        for (IUObj *iu in allIUs) {
            if ([newName isEqualToString:iu.htmlID]) {
                continue;
            }
        }
        break;
        
    }
    return newName;
    NSAssert(IDDict != nil, @"IUDict is nil");
    
    NSString *className = NSStringFromClass(class);
    if (IDDict[className] == nil) {
        IDDict[className] = @(0);
    }
    else {
        IDDict[className] = @([IDDict[className] intValue] + 1);
    }
    int index = [IDDict[className] intValue];
    return [NSString stringWithFormat:@"%@%d", [NSStringFromClass(class) substringFromIndex:2], index];
}

+(NSString*)createProject:(NSDictionary*)setting error:(NSError**)error{
    IUProject *project = [[IUProject alloc] init];
    project.name = [setting objectForKey:IUProjectKeyAppName];
    project.compiler = [[IUCompiler alloc] init];
    
    NSString *dir = [setting objectForKey:IUProjectKeyDirectory];
    project.path = [dir stringByAppendingPathComponent:[project.name stringByAppendingPathExtension:@"iuproject"]];
    [JDFileUtil rmDirPath:[project.path stringByAppendingPathExtension:@"*"]];
    ReturnNilIfFalse([JDFileUtil mkdirPath:project.path]);
    
    IUDocumentGroupNode *pageDir = [[IUDocumentGroupNode alloc] init];
    pageDir.name = @"Page";
    [project addDocumentGroupNode:pageDir];
    project.pageDocumentGroup = pageDir;
    /*
     IUDocumentGroup *compDir = [[IUDocumentGroup alloc] initWithName:@"Component"];
     [self addDocumentGroupNode:compDir];
     componentDocumentGroup = compDir;

     */
    
    IUDocumentGroupNode *masterGroup = [[IUDocumentGroupNode alloc] init];
    [project addDocumentGroupNode:masterGroup];
    masterGroup.name = @"Master";
    project.masterDocumentGroup = masterGroup;
    
    
    IUPage *page = [[IUPage alloc] initWithProject:project setting:setting];
    page.name = @"root";
    page.project = project;
    page.htmlID = [project requestNewID:[IUPage class]];
    [pageDir addDocument:page name:@"Index"];
    
    IUMaster *master = [[IUMaster alloc] initWithProject:project setting:setting];
    master.name = @"master";
    master.project = project;
    master.htmlID = [project requestNewID:[IUMaster class]];
    [masterGroup addDocument:master name:@"Master"];
    page.master = master;

    
    //make resource dir
    ReturnNilIfFalse([project makeResourceDir]);

    ReturnNilIfFalse([project save]);
    return project.path;
}


+ (id)projectWithContentsOfPackage:(NSString*)path{
    IUProject *project = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"IUML"]];
    return project;
}

-(NSString*)path{
    return _path;
}

-(NSString*)IUMLPath{
    return [_path stringByAppendingPathComponent:@"IUML"];
}



-(BOOL)makeResourceDir{
    NSAssert(_path != nil, @"path is nil");
    
    IUResourceGroupNode *resGroup = [[IUResourceGroupNode alloc] init];
    resGroup.name = @"Resource";
    resGroup.parent = self;
    [self addNode:resGroup];

    IUResourceGroupNode *imageGroup = [[IUResourceGroupNode alloc] init];
    imageGroup.name = @"Image";
    imageGroup.parent = resGroup;
    [resGroup addNode:imageGroup];
    ReturnNoIfFalse([imageGroup syncDir]);
    
    
    NSData *sampleImg = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sample" ofType:@"jpg"]];
    NSAssert([self insertData:sampleImg name:@"sample.jpg" group:imageGroup], @"sample.jpg failure");
    
    IUResourceGroupNode *CSSGroup = [[IUResourceGroupNode alloc] init];
    CSSGroup.name = @"CSS";
    CSSGroup.parent = resGroup;
    [resGroup addNode:CSSGroup];
    ReturnNoIfFalse([CSSGroup syncDir]);
    
    NSData *cssData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"reset" ofType:@"css"]];
    NSAssert([self insertData:cssData name:@"reset.css" group:CSSGroup], @"reset.css failure");
    
    NSData *iuCssData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iu" ofType:@"css"]];
    NSAssert([self insertData:iuCssData name:@"iu.css" group:CSSGroup], @"iu.css failure");
    
    IUResourceGroupNode *JSGroup = [[IUResourceGroupNode alloc] init];
    JSGroup.name = @"JS";
    JSGroup.parent = resGroup;
    [resGroup addNode:JSGroup];
    ReturnNoIfFalse([JSGroup syncDir]);
    
    NSData *jsFrameData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iuframe" ofType:@"js"]];
    NSAssert([self insertData:jsFrameData name:@"iuframe.js" group:JSGroup], @"iuframe.js failure");

    return YES;
}

-(BOOL)insertData:(NSData*)data name:(NSString*)name group:(IUResourceGroupNode*)resourceGroup{
    assert(data != nil && name!=nil && resourceGroup != nil);
    ReturnNoIfFalse([data writeToFile:[resourceGroup.absolutePath stringByAppendingPathComponent:name] atomically:YES]);
    IUResourceNode *newNode = [[IUResourceNode alloc] initWithName:name parent:resourceGroup];
    [resourceGroup addNode:newNode];
    

    if ([[NSImage alloc] initWithData:data]) {
        [self willChangeValueForKey:@"imageNames"];
        [self willChangeValueForKey:@"resourcePaths"];
        [_imageNames addObject:name];
        [_resourcePaths setObject:newNode.relativePath forKey:name];
        [self willChangeValueForKey:@"resourcePaths"];
        [self didChangeValueForKey:@"imageNames"];
    }

    return YES;
}

-(NSArray*)imageNames{
    return _imageNames;
}

-(NSDictionary*)resourcePaths{
    return _resourcePaths;
}

- (void)build:(NSError**)error{
    
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

-(NSArray*)allDocuments{
    NSMutableArray  *array = [NSMutableArray arrayWithArray:self.pageDocuments];
    [array addObjectsFromArray:self.masterDocuments];
    [array addObjectsFromArray:self.componentDocuments];
    return [array copy];
}

- (NSArray*)pageDocuments{
    return [_pageDocumentGroup allDocuments];
}

- (NSArray*)masterDocuments{
    return [_masterDocumentGroup allDocuments];
}

- (NSArray*)componentDocuments{
    return [_componentDocumentGroup allDocuments];
}


@end