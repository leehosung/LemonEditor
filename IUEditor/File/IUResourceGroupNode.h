//
//  IUResourceGroup.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUGroupNode.h"
@class IUResourceNode;

@protocol IUResourceGroupNode <NSObject>
@required
- (NSString*)relativePath;
- (NSString*)absolutePath;
-(void)addResourceGroupNode:(IUNode<IUResourceGroupNode> *)node;
@end

@interface IUResourceGroupNode : IUGroupNode <IUResourceGroupNode>

-(void)addResourceNode:(IUResourceNode*)node data:(NSData*)data;
-(void)addResourceNode:(IUResourceNode*)node path:(NSString*)path;

@end