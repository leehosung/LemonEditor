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
}



- (void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:_herokuOn forKey:@"herokuOn"];
    [encoder encodeInt32:_gitType forKey:@"gitType"];
    [encoder encodeObject:_path forKey:@"path"];
    [encoder encodeObject:IDDict forKey:@"IDDict"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _compiler = [[IUCompiler alloc] init];
        _herokuOn = [aDecoder decodeBoolForKey:@"herokuOn"];
        _gitType = [aDecoder decodeInt32ForKey:@"gitType"];
        _path = [aDecoder decodeObjectForKey:@"path"];
        IDDict = [aDecoder decodeObjectForKey:@"IDDict"];
        
    }
    return self;
}

- (id)init{
    self = [super init];
    IDDict = [NSMutableDictionary dictionary];
    return self;
}

-(NSString*)requestNewID:(Class)class{
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
    
    
    //make resource dir
    ReturnNilIfFalse([project makeResourceDir]);
    
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
    
    IUResourceGroupNode *externalGroup = [[IUResourceGroupNode alloc] init];
    externalGroup.name = @"External";
    externalGroup.parent = resGroup;
    [resGroup addNode:externalGroup];
    
    ReturnNoIfFalse([imageGroup syncDir]);
    ReturnNoIfFalse([externalGroup syncDir]);
    
    NSData *cssData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"reset" ofType:@"css"]];
    NSAssert([self insertData:cssData name:@"reset.css" group:externalGroup], @"reset.css failure");
    
    NSData *iuCssData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iu" ofType:@"css"]];
    NSAssert([self insertData:iuCssData name:@"iu.css" group:externalGroup], @"iu.css failure");

    return YES;
}

-(BOOL)insertData:(NSData*)data name:(NSString*)name group:(IUResourceGroupNode*)resourceGroup{
    assert(data != nil && name!=nil && resourceGroup != nil);
    ReturnNoIfFalse([data writeToFile:[resourceGroup.path stringByAppendingPathComponent:name] atomically:YES]);
    IUResourceNode *newNode = [[IUResourceNode alloc] init];
    newNode.name = name;
    [resourceGroup addNode:newNode];
    return YES;
    
}

- (void)build:(NSError**)error{
    
}


-(BOOL)save{
    return [NSKeyedArchiver archiveRootObject:self toFile:[self IUMLPath]];
}


- (void)addImageResource:(NSImage*)image{
    assert(0);
}

- (NSArray*)pageDocuments{
    return _pageDocumentGroup.children;
}

- (NSArray*)masterDocuments{
    return _masterDocumentGroup.children;
}

- (NSArray*)componentDocuments{
    return _componentDocumentGroup.children;
}


@end