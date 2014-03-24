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
#import "IUResourceGroup.h"
#import "IUDocumentControllerNode.h"

@implementation IUProject{
    NSString *path;
    IUDocumentGroupNode *pageDocumentGroup;
    IUDocumentGroupNode *masterDocumentGroup;
    IUDocumentGroupNode *componentDocumentGroup;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    
    [encoder encodeFromObject:self withProperties:[[IUProject class] properties]];
    [encoder encodeObject:pageDocumentGroup   forKey:@"pageDocumentGroup"];
    [encoder encodeObject:masterDocumentGroup     forKey:@"masterDocumentGroup"];
    [encoder encodeObject:componentDocumentGroup forKey:@"componentDocumentGroup"];
    [encoder encodeObject:path forKey:@"path"];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUProject class] properties]];
        pageDocumentGroup     = [aDecoder decodeObjectForKey:@"pageDocumentGroup"];
        masterDocumentGroup       = [aDecoder decodeObjectForKey:@"masterDocumentGroup"];
        componentDocumentGroup   = [aDecoder decodeObjectForKey:@"componentDocumentGroup"];
        path            = [aDecoder decodeObjectForKey:@"path"];
    }
    return self;
}

-(id)init:(NSDictionary *)setting error:(NSError *__autoreleasing *)error{
    self = [super init];
    
    self.name = [setting objectForKey:IUProjectKeyAppName];
    
    NSString *dir = [setting objectForKey:IUProjectKeyDirectory];
    path = [dir stringByAppendingPathComponent:[self.name stringByAppendingPathExtension:@"iuproject"]];
    
    ReturnNilIfFalse([JDFileUtil mkdirPath:path]);
    
    IUDocumentGroupNode *pageDir = [[IUDocumentGroupNode alloc] init];
    pageDir.name = @"Page";
    [self addDocumentGroup:pageDir];
    pageDocumentGroup = pageDir;
    
    IUDocumentGroupNode *compDir = [[IUDocumentGroupNode alloc] init];
    compDir.name = @"Compnent";
    [self addDocumentGroup:compDir];
    componentDocumentGroup = compDir;
    
    IUDocumentGroupNode *masterDocumentDir = [[IUDocumentGroupNode alloc] init];
    masterDocumentDir.name = @"Master";
    [self addDocumentGroup:masterDocumentDir];
    masterDocumentGroup = masterDocumentDir;

    
    //make resource dir
    ReturnNilIfFalse([self makeResourceDir]);

    IUPage *page = [[IUPage alloc] init];
    page.name = @"index";
    [pageDir addDocument:page];
    
    ReturnNilIfFalse([self save]);
    
    return self;
}

+ (id)projectWithContentsOfPackage:(NSString*)path{
    IUProject *project = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"IUML"]];
    return project;
}

-(NSString*)path{
    return path;
}

-(NSString*)IUMLPath{
    return [path stringByAppendingPathComponent:@"IUML"];
}



-(BOOL)makeResourceDir{
    NSAssert(path != nil, @"path is nil");
    
    IUResourceGroup *resGroup = [[IUResourceGroup alloc] init];
    resGroup.parent = self;
    [resGroup setName:@"Resource"];
    [[self children] addObject:resGroup];

    IUResourceGroup *imageGroup = [[IUResourceGroup alloc] init];
    imageGroup.parent = resGroup;
    [imageGroup setName:@"Image"];
    [[resGroup children] addObject:imageGroup];
    ReturnNoIfFalse([imageGroup syncDir]);
    
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