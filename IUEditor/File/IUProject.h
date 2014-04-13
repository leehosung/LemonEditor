//
//  IUProject.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUDocumentGroupNode.h"
#import "IUResourceGroupNode.h"

@class IUCompiler;
typedef enum _IUGitType{
    IUGitTypeNone = 0,
    IUGitTypeSource = 1,
    IUGitTypeOutput = 2
} IUGitType;

@class IUProject;
@protocol IUProjectDelegate
-(void)project:(IUProject*)project nodeAdded:(IUNode*)node;
@end


@class IUDocument;

@interface IUProject : IUDocumentGroupNode <IUResourceGroupNode>

@property   BOOL            herokuOn;
@property   IUGitType       gitType;
@property   id<IUProjectDelegate>  delegate;

//setting
#define IUProjectKeyGit @"git"
#define IUProjectKeyAppName @"appName"
#define IUProjectKeyHeroku @"heroku"
#define IUProjectKeyDirectory @"dir"

+ (id)projectWithContentsOfPackage:(NSString*)path;
+(NSString*)createProject:(NSDictionary*)setting error:(NSError**)error;

- (BOOL)save;
- (void)build:(NSError**)error;

- (NSArray*)pageDocuments;
- (NSArray*)masterDocuments;
- (NSArray*)componentDocuments;

- (IUResourceGroupNode*)resourceNode;
@end