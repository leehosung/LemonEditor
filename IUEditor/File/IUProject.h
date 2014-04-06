//
//  IUProject.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUDocumentGroupNode.h"

@class IUCompiler;
typedef enum _IUGitType{
    IUGitTypeNone = 0,
    IUGitTypeSource = 1,
    IUGitTypeOutput = 2
} IUGitType;

@class IUDocument;

@interface IUProject : IUDocumentGroupNode

@property   BOOL            herokuOn;
@property   IUGitType       gitType;
@property   IUCompiler      *compiler;


//resource management
//KVO - compliant
-(NSArray*)imageNames;
-(NSDictionary*)resourcePathes;

//setting
#define IUProjectKeyGit @"git"
#define IUProjectKeyAppName @"appName"
#define IUProjectKeyHeroku @"heroku"
#define IUProjectKeyDirectory @"dir"

+ (id)projectWithContentsOfPackage:(NSString*)path;
+(NSString*)createProject:(NSDictionary*)setting error:(NSError**)error;

- (BOOL)save;
- (void)build:(NSError**)error;
//- (void)sync:(NSError**)error;

//- (void)addImage:(NSImage*)image;

//used to check resource dir path
- (NSString*)path;
- (NSString*)requestNewID:(Class)class;

- (NSArray*)pageDocuments;
- (NSArray*)masterDocuments;
- (NSArray*)componentDocuments;

@end