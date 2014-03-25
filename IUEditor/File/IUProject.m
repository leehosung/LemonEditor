//
//  IUProject.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUProject.h"
#import "IUPage.h"
#import "IUDocumentGroup.h"
#import "IUResourceGroup.h"

@interface IUProject()
@property (nonatomic, copy) NSString          *path;
@property IUDocumentGroup *pageDocumentGroup;
@property IUDocumentGroup *masterDocumentGroup;
@property IUDocumentGroup *componentDocumentGroup;
@end

@implementation IUProject{
}



- (void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    
    [encoder encodeFromObject:self withProperties:[[IUProject class] properties]];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUProject class] properties]];
    }
    return self;
}

+(NSString*)createProject:(NSDictionary*)setting error:(NSError**)error{
    IUProject *project = [[IUProject alloc] init];
    project.name = [setting objectForKey:IUProjectKeyAppName];
    
    NSString *dir = [setting objectForKey:IUProjectKeyDirectory];
    project.path = [dir stringByAppendingPathComponent:[project.name stringByAppendingPathExtension:@"iuproject"]];
    
    ReturnNilIfFalse([JDFileUtil mkdirPath:project.path]);
    
    IUDocumentGroup *pageDir = [[IUDocumentGroup alloc] init];
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
    
    IUPage *page = [[IUPage alloc] init];
    page.name = @"index";
    [pageDir addDocument:page];
    
    ReturnNilIfFalse([project save]);
    return project.path;
}

-(id)init:(NSDictionary *)setting error:(NSError *__autoreleasing *)error{
    return self;
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
    
    IUResourceGroup *resGroup = [[IUResourceGroup alloc] init];
    resGroup.name = @"Resource";
    resGroup.parent = self;
    [[self children] addObject:resGroup];
/*
    IUResourceGroup *imageGroup = [[IUResourceGroup alloc] initWithName:@"Image"];
    imageGroup.parent = resGroup;
    [[resGroup children] addObject:imageGroup];
    ReturnNoIfFalse([imageGroup syncDir]);
  */
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