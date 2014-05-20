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
-(void)project:(IUProject*)project nodeRemoved:(IUNode*)node;
@end


@class IUDocument;

//setting
static NSString * IUProjectKeyGit = @"git";
static NSString * IUProjectKeyAppName = @"appName";
static NSString * IUProjectKeyHeroku = @"heroku";
static NSString * IUProjectKeyDirectory = @"dir";

@interface IUProject : IUDocumentGroupNode <IUResourceGroupNode>
@property (nonatomic, copy) NSString          *path;
@property IUDocumentGroupNode *pageDocumentGroup;
@property IUDocumentGroupNode *backgroundDocumentGroup;
@property IUDocumentGroupNode *classDocumentGroup;
- (void)initializeResource;

@property   BOOL            herokuOn;
@property   IUGitType       gitType;
@property   id<IUProjectDelegate>  delegate;
@property   NSString        *buildDirectoryName;
@property   NSMutableArray  *mqSizes;

- (NSString*)path;


+ (id)projectWithContentsOfPackage:(NSString*)path;
+ (IUProject*)createProject:(NSDictionary*)setting error:(NSError**)error;

- (BOOL)save;
- (BOOL)build:(NSError**)error;

- (NSArray*)pageDocuments;
- (NSArray*)backgroundDocuments;
- (NSArray*)classDocuments;

@property (nonatomic) IUResourceGroupNode *resourceNode;

- (NSArray*)allDocumentNodes;
- (NSArray*)pageDocumentNodes;
- (NSArray*)backgroundDocumentNodes;
- (NSArray*)classDocumentNodes;

- (void)copyResourceForDebug;

@end