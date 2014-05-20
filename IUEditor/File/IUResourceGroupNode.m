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
#import "IUProject.h"

@implementation IUResourceGroupNode{
}

-(NSString*)relativePath{
    return [[(IUResourceGroupNode*)self.parent relativePath] stringByAppendingPathComponent:self.name];
}

-(NSString*)absolutePath{
    if ([self.parent isKindOfClass:[IUProject class]]) {
        return [((IUProject*)self.parent).absoluteDirectory stringByAppendingPathComponent:self.name];
    }
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
    NSError *err;
    if ([[NSFileManager defaultManager] fileExistsAtPath:node.absolutePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:node.absolutePath error:&err];
    }
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:node.absolutePath error:&err];
}



@end
