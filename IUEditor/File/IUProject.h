//
//  IUProject.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUFileGroup.h"

typedef enum _IUGitType{
    IUGitTypeNone = 0,
    IUGitTypeSource = 1,
    IUGitTypeOutput = 2
} IUGitType;


@interface IUProject : IUFileGroup

@property   BOOL            herokuOn;
@property   IUGitType       gitType;
@property   NSSize          *size;
@property   NSRect          *rect;
@property   CGRect          *cRect;
@property   NSPoint          *point;
@property   CGPoint          *cpoint;


- (id)initAtDirectory:(NSString*)path name:(NSString*)name git:(IUGitType)gitType heroku:(BOOL)heroku error:(NSError *__autoreleasing *)error;
+ (id)projectWithContentsOfPackage:(NSString*)path;

- (BOOL)save;

- (void)build:(NSError**)error;
- (void)sync:(NSError**)error;

- (void)addImageResource:(NSImage*)image;
-(NSString*)dirPath;
@end