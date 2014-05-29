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

@property (nonatomic) IUResourceGroup *rootNode;

-(IUResourceFile*)insertResourceWithData:(NSData*)data type:(IUResourceType)type;
-(IUResourceFile*)insertResourceWithContentOfPath:(NSString*)path type:(IUResourceType)type;

//KVO compliance
-(NSArray*)imagePaths;
-(NSArray*)videoPaths;
-(NSArray*)imageNames;
-(NSArray *)videoNames;
-(NSArray*)resourceNodes;

- (IUResourceGroup *)imageNode;
- (IUResourceGroup *)videoNode;
- (IUResourceGroup *)jsNode;
- (IUResourceGroup *)cssNode;

-(IUResourceType)resourceType:(NSString *)anExtension;
-(IUResourceFile*)imageResourceNodeOfName:(NSString*)imageName;
@end