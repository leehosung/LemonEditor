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

@interface IUResourceManager : NSObject <IUCompilerResourceSource>

- (IUResourceGroup *)resourceGroup;
- (void)setResourceGroup:(IUResourceGroup*)resourceRootGroup;
- (IUResourceFile*)insertResourceWithContentOfPath:(NSString*)path;

/**
 @breif Getting contents in image resource group
 @return Array of IUResourceFile
 @note KVO-compliance
 */
-(NSArray*)imageFiles;

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

-(IUResourceType)resourceType:(NSString *)anExtension;
-(IUResourceFile*)resourceFileWithName:(NSString*)imageName;
@end