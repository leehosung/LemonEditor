//
//  IUProject.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUResourceGroup.h"
#import "IUCompiler.h"
#import "IUSheetGroup.h"
#import "IUFileProtocol.h"

typedef enum _IUGitType{
    IUGitTypeNone = 0,
    IUGitTypeSource = 1,
    IUGitTypeOutput = 2
} IUGitType;

typedef enum {
    IUProjectTypeDefault,
    IUProjectTypeDjango,
    IUProjectTypePresentation,
} IUProjectType;


//setting
static NSString * IUProjectKeyType = @"projectType";
static NSString * IUProjectKeyGit = @"git";
static NSString * IUProjectKeyAppName = @"appName";
static NSString * IUProjectKeyHeroku = @"heroku";
static NSString * IUProjectKeyPath= @"path";

@interface IUProject : NSObject <IUFile, IUResourcePathProtocol>{
    IUSheetGroup *_pageGroup;
    IUSheetGroup *_backgroundGroup;
    IUSheetGroup *_classGroup;
    IUResourceGroup *_resourceGroup;
    
    IUCompiler *_compiler;
    IUResourceManager *_resourceManager;
    IUIdentifierManager *_identifierManager;
    
    NSString *_buildPath;
    NSString  *_path;
    NSMutableArray *_mqSizes;
}

//create project
+ (id)projectWithContentsOfPath:(NSString*)path;
+ (NSString *)stringProjectType:(IUProjectType)type;

/**
 @breif create project
 @param setting a dictionary which has IUProjectKeyAppName and IUProjectKeyDirectory
 */
-(id)initWithCreation:(NSDictionary*)options error:(NSError**)error;
- (void)initializeResource;

//save project
- (BOOL)save;

//project properties
- (NSArray*)mqSizes;
- (void)addMQSize:(NSInteger)size;
- (void)removeMQSize:(NSInteger)size;

/*
 @ important
 name , path are set by IUProjectDocument
 */
@property   NSString  *name;
@property   NSString *path;

- (NSString*)directoryPath;
- (NSString*)buildPath;

//build
- (IUCompiler *)compiler;
- (BOOL)build:(NSError**)error;


//manager
- (IUIdentifierManager*)identifierManager;
- (IUResourceManager *)resourceManager;

- (NSArray*)allDocuments;
- (NSArray*)pageDocuments;
- (NSArray*)backgroundDocuments;
- (NSArray*)classDocuments;

- (void)copyResourceForDebug;

- (BOOL)runnable;

// return groups
- (IUSheetGroup*)pageGroup;
- (IUSheetGroup*)backgroundGroup;
- (IUSheetGroup*)classGroup;

- (void)addSheet:(IUSheet *)sheet toSheetGroup:(IUSheetGroup *)sheetGroup;
- (void)removeSheet:(IUSheet *)sheet toSheetGroup:(IUSheetGroup *)sheetGroup;

@end