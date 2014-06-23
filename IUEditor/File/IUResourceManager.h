//
//  IUResourceManager.h
//  IUEditor
//
//  Created by JD on 4/6/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUResourceGroup.h"
#import "IUResourceFile.h"
#import "IUCompilerResourceSource.h"

@interface IUResourceManager : NSObject

- (void)setResourceGroup:(IUResourceGroup*)resourceRootGroup;
- (IUResourceFile*)insertResourceWithContentOfPath:(NSString*)path;
- (IUResourceFile *)overwriteResourceWithContentOfPath:(NSString *)path;

/**
 @breif Getting contents in image resource group
 @return Array of IUResourceFile
 @note KVO-compliance
 */
-(NSArray*)imageFiles;

-(NSString*)imageDirectory;

/**
 @breif Getting contents in image resource group
 @return Array of IUResourceFile
 @note KVO-compliance
 */
-(NSArray*)videoFiles;

/**
 @breif Getting contents in image and video resource group
 @return Array of IUResourceFile
 @note KVO-compliance
 */
-(NSArray*)imageAndVideoFiles;

//For saving
-(NSArray *)jsFiles;
-(NSArray *)cssFiles;
- (NSArray *)namesWithFiles:(NSArray *)files;
-(IUResourceFile*)resourceFileWithName:(NSString*)imageName;
@end