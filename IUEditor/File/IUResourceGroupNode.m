//
//  IUResourceGroup.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResourceGroupNode.h"
#import "IUResourceNode.h"
#import "JDFileUtil.h"

@implementation IUResourceGroupNode{
}

-(NSString*)relativePath{
    return [[(IUResourceGroupNode*)self.parent relativePath] stringByAppendingPathComponent:self.name];
}

-(NSString*)absolutePath{
    return [[(IUResourceGroupNode*)self.parent absolutePath] stringByAppendingPathComponent:self.name];
}

-(void)addResourceGroupNode:(IUNode<IUResourceGroupNode> *)node{
    [super addNode:node];
    [[NSFileManager defaultManager] createDirectoryAtPath:node.absolutePath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(void)addResourceNode:(IUResourceNode*)node data:(NSData*)data{
    [super addNode:node];
    [[NSFileManager defaultManager] createFileAtPath:node.absolutePath contents:data attributes:nil];

}

-(void)addResourceNode:(IUResourceNode*)node path:(NSString*)path{
    [super addNode:node];
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:node.absolutePath error:nil];
}



@end
