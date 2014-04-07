//
//  IUResourceManager.m
//  IUEditor
//
//  Created by JD on 4/6/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResourceManager.h"

@interface IUResourceManager ()
@end

@implementation IUResourceManager{
}

-(NSString*)relativePathForResource:(NSString*)name{
    IUResourceNode *node = (IUResourceNode*)[self nodeWithName:name];
    return node.relativePath;
}


-(IUResourceNode*)insertResourceWithData:(NSData*)data type:(IUResourceType)type{
    assert(0);
    return nil;
}

-(IUNode*)nodeWithName:(NSString*)name{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", name];
    return [[[_rootNode.allChildren arrayByAddingObject:_rootNode] filteredArrayUsingPredicate:predicate] firstObject];
}

-(IUResourceNode*)insertResourceWithContentOfPath:(NSString*)path type:(IUResourceType)type{
    
    NSString *groupName;
    switch (type) {
        case IUResourceTypeCSS:{
            groupName=@"CSS"; break;
        }
        case IUResourceTypeJS: groupName=@"JS"; break;
        case IUResourceTypeImage:{
            [self willChangeValueForKey:@"imageResourceNodes"];
            [self willChangeValueForKey:@"imageNames"];
            [self willChangeValueForKey:@"imagePaths"];
            groupName=@"Image"; break;
        }
        default: assert(0);  break;
    }
    
    IUResourceNode *resourceNode = [[IUResourceNode alloc] initWithName:[path lastPathComponent] type:type];
    IUResourceGroupNode *parent = (IUResourceGroupNode*)[self nodeWithName:groupName];
    [parent addResourceNode:resourceNode path:path];
    if (type == IUResourceTypeCSS) {
        [self didChangeValueForKey:@"imagePaths"];
        [self didChangeValueForKey:@"imageNames"];
        [self didChangeValueForKey:@"imageResourceNodes"];
    }
    return resourceNode;
}

-(NSArray*)imagePaths{
    NSArray *nodes = _rootNode.allChildren;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[IUResourceNode class]]) {
            if (((IUResourceNode*)evaluatedObject).type == IUResourceTypeImage) {
                return YES;
            }
        }
        return NO;
    }];
    NSArray *imageNodes = [nodes filteredArrayUsingPredicate:predicate];
    NSArray *ret = [imageNodes valueForKeyPath:@"relativePath"];
    return ret;
}

-(void)setRootNode:(IUResourceGroupNode *)rootNode{
    [self willChangeValueForKey:@"imageResourceNodes"];
    [self willChangeValueForKey:@"imageNames"];
    [self willChangeValueForKey:@"imagePaths"];
    _rootNode = rootNode;
    [self didChangeValueForKey:@"imagePaths"];
    [self didChangeValueForKey:@"imageNames"];
    [self didChangeValueForKey:@"imageResourceNodes"];
}

-(NSArray*)imageNames{
    NSArray *ret = [self.imagePaths valueForKeyPath:@"lastPathComponent"];
    return ret;
}

-(NSArray*)imageResourceNodes{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUResourceNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[IUResourceNode class]]) {
            if (evaluatedObject.type == IUResourceTypeImage) {
                return YES;
            }
        }
        return NO;
    }];
    return [_rootNode.allChildren filteredArrayUsingPredicate:predicate];
}


@end
