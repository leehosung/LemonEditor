//
//  IUResourceManager.h
//  IUEditor
//
//  Created by JD on 4/6/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUResourceGroupNode.h"
#import "IUResourceNode.h"
#import "IUCompilerResourceSource.h"

@interface IUResourceManager : NSObject <IUCompilerResourceSource>

@property (nonatomic) IUResourceGroupNode *rootNode;

-(IUResourceNode*)insertResourceWithData:(NSData*)data type:(IUResourceType)type;
-(IUResourceNode*)insertResourceWithContentOfPath:(NSString*)path type:(IUResourceType)type;

//KVO compliance
-(NSArray*)imagePaths;
-(NSArray*)videoPaths;
-(NSArray*)imageNames;
-(NSArray *)videoNames;
-(NSArray*)resourceNodes;

- (IUResourceGroupNode *)imageNode;
- (IUResourceGroupNode *)videoNode;

@end
