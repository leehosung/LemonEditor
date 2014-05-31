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
#import "IUDocumentGroup.h"
#import "IUFileProtocol.h"

typedef enum _IUGitType{
    IUGitTypeNone = 0,
    IUGitTypeSource = 1,
    IUGitTypeOutput = 2
} IUGitType;



//setting
static NSString * IUProjectKeyGit = @"git";
static NSString * IUProjectKeyAppName = @"appName";
static NSString * IUProjectKeyHeroku = @"heroku";
static NSString * IUProjectKeyDirectory = @"dir";

@interface IUProject : NSObject <IUFile>{
    IUDocumentGroup *_pageGroup;
    IUDocumentGroup *_backgroundGroup;
    IUDocumentGroup *_classGroup;
    IUResourceGroup *_resourceGroup;
    NSString *_buildPath;
}

//create project
+ (id)projectWithContentsOfPath:(NSString*)path;

/**
 @breif create project
 @param setting a dictionary which has IUProjectKeyAppName and IUProjectKeyDirectory
 */
-(id)initWithCreation:(NSDictionary*)options error:(NSError**)error;
- (void)initializeResource;

//save project
- (BOOL)save;

//project properties
@property   NSMutableArray  *mqSizes;
@property   NSString        *name;

//set path
- (void)setPath:(NSString*)path;
- (NSString*)path;
- (NSString*)directory;
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
@end