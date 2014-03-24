//
//  IUProject.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUDocumentGroupNode.h"

typedef enum _IUGitType{
    IUGitTypeNone = 0,
    IUGitTypeSource = 1,
    IUGitTypeOutput = 2
} IUGitType;

@class IUDocument;

@interface IUProject : IUDocumentGroupNode

@property   BOOL            herokuOn;
@property   IUGitType       gitType;


//setting
#define IUProjectKeyGit @"git"
#define IUProjectKeyAppName @"appName"
#define IUProjectKeyHeroku @"heroku"
#define IUProjectKeyDirectory @"dir"

- (id)init:(NSDictionary*)setting error:(NSError**)error;
+ (id)projectWithContentsOfPackage:(NSString*)path;

#define IUDocumentKeyType @"type"
#define IUDocumentKeyName @"name"
- (IUDocument*)createDocument:(NSDictionary*)document;

- (BOOL)save;
- (void)build:(NSError**)error;
- (void)sync:(NSError**)error;

- (void)addImage:(NSImage*)image;

//used to check resource dir path
- (NSString*)path;


@end