//
//  IUProject.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUProject.h"
#import "JDFileUtil.h"
#import "NSString+JDExtension.h"
#import "NSDictionary+JDExtension.h"
#import "JDShortcut.h"
#import "IUPage.h"
#import "IUFileGroup.h"
#import "IUResourceGroup.h"
#import "IUFile.h"

@implementation IUProject{
    NSString *IUMLPath;
    IUFileGroup *masterFileGroup;
    IUFileGroup *pageFileGroup;
    IUFileGroup *compnentFileGroup;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.childNodes forKey:@"childNode"];
    [encoder encodeBool:_herokuOn forKey:@"herokuOn"];
    [encoder encodeInt:_gitType forKey:@"gitType"];
    [encoder encodeObject:masterFileGroup forKey:@"masterFileGroup"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *childNodes = [aDecoder decodeObjectForKey:@"childNode"];
        masterFileGroup = [aDecoder decodeObjectForKey:@"masterFileGroup"];
        [[self mutableChildNodes] addObjectsFromArray:childNodes];

        _herokuOn = [aDecoder decodeBoolForKey:@"herokuOn"];
        _gitType = [aDecoder decodeIntForKey:@"gitType"];
    }
    return self;
}


-(NSString*)dirPath{
    return [IUMLPath stringByDeletingLastPathComponent];
}

-(NSString*)IUMLPath{
    return IUMLPath;
}


//TODO: Git, Heroku Not implemented
- (id)initAtDirectory:(NSString*)_path name:(NSString *)name git:(IUGitType)gitType heroku:(BOOL)heroku error:(NSError *__autoreleasing *)error{
    self = [super init];

    _name = name;
    
    //make directory path/name.iuproject
    NSString *projectDir = [_path stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"iuproject"]];
    IUMLPath = [projectDir stringByAppendingPathComponent:@"IUML"];

    ReturnNilIfFalse([JDFileUtil mkdirPath:projectDir]);
    
    //make resource dir
    ReturnNilIfFalse([self makeResourceDir:projectDir]);
    
    IUFileGroup *pageDir = [[IUFileGroup alloc] initWithName:@"Page"];
    IUFile      *pageFile = [[IUFile alloc] initAsPageWithName:@"index"];
    [[self mutableChildNodes] addObject:pageDir];
    [[pageDir mutableChildNodes] addObject:pageFile];
    
    IUFileGroup *compDir = [[IUFileGroup alloc] initWithName:@"Component"];
    //IUFile      *compFile = [[[IUFile alloc] init] initAsComponentWithName:@"part"];
    [[self mutableChildNodes] addObject:compDir];
    //[[compDir mutableChildNodes] addObject:compFile];
    
    masterFileGroup = [[IUFileGroup alloc] initWithName:@"Master"];
    //IUFile      *masterFile = [[[IUFile alloc] init] initAsMasterWithName:@"master"];
    [[self mutableChildNodes] addObject:masterFileGroup];
    //[[compDir mutableChildNodes] addObject:masterFile];
    
    
    ReturnNilIfFalse([self save]);
    
    return self;
}

+ (id)projectWithContentsOfPackage:(NSString*)path{
    IUProject *project = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"IUML"]];
    return project;
}



-(BOOL)makeResourceDir:(NSString*)path{
    IUResourceGroup *resGroup = [[IUResourceGroup alloc] init];
    [resGroup setName:@"Resource"];
    [[self mutableChildNodes] addObject:resGroup];

    IUResourceGroup *imageGroup = [[IUResourceGroup alloc] init];
    [imageGroup setName:@"Image"];
    [[resGroup mutableChildNodes] addObject:imageGroup];
    ReturnNoIfFalse([imageGroup syncDir]);
    
    IUResourceGroup *movieGroup = [[IUResourceGroup alloc] init];
    [movieGroup setName:@"Movie"];
    [[resGroup mutableChildNodes] addObject:movieGroup];
    
    ReturnNoIfFalse([imageGroup syncDir]);

    return YES;
}

- (void)build:(NSError**)error{
    
}


-(BOOL)save{
    return [NSKeyedArchiver archiveRootObject:self toFile:IUMLPath];
}


- (void)addImageResource:(NSImage*)image{
    assert(0);
}


@end