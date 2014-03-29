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
        
        for (IUDocumentNode *node in self.allChildren) {
            if ([node isKindOfClass:[IUDocumentNode class]]) {
                [node.document bind:@"compiler" toObject:self withKeyPath:@"compiler" options:nil];
            }
        }
    }
    return self;
}

-(NSString*)requestNewID:(Class)class{
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
    [project addDocumentGroup:pageDir];
    project.pageDocumentGroup = pageDir;
    /*
     IUDocumentGroup *compDir = [[IUDocumentGroup alloc] initWithName:@"Component"];
     [self addDocumentGroup:compDir];
     componentDocumentGroup = compDir;
     
     IUDocumentGroup *masterDocumentDir = [[IUDocumentGroup alloc] initWithName:@"Master"];
     [self addDocumentGroup:masterDocumentDir];
     masterDocumentGroup = masterDocumentDir;
     */
    
    //make resource dir
    ReturnNilIfFalse([project makeResourceDir]);
    
    IUPage *page = [[IUPage alloc] initWithSetting:nil];
    page.name = @"root";
    page.htmlID = [project requestNewID:[IUPage class]];
    [page.css setStyle:IUCSSTagBGColor value:[NSColor randomColor]]  ;
    [pageDir addDocument:page name:@"Index"];
    
    [page bind:@"compiler" toObject:project withKeyPath:@"compiler" options:nil];
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


@end