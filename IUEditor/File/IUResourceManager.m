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

-(NSString*)absolutePathForResource:(NSString*)name{
    IUResourceNode *node = (IUResourceNode*)[self nodeWithName:name];
    return node.absolutePath;
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
        case IUResourceTypeVideo:{
            [self willChangeValueForKey:@"resourceNodes"];
            [self willChangeValueForKey:@"videoNames"];
            [self willChangeValueForKey:@"videoPaths"];
            groupName=@"Video"; break;
        }
        case IUResourceTypeImage:{
            [self willChangeValueForKey:@"resourceNodes"];
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
        [self didChangeValueForKey:@"videoPaths"];
        [self didChangeValueForKey:@"videoNames"];
        [self didChangeValueForKey:@"imagePaths"];
        [self didChangeValueForKey:@"imageNames"];
        [self didChangeValueForKey:@"resourceNodes"];
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

-(NSArray*)videoPaths{
    NSArray *nodes = _rootNode.allChildren;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[IUResourceNode class]]) {
            if (((IUResourceNode*)evaluatedObject).type == IUResourceTypeVideo) {
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
    [self willChangeValueForKey:@"resourceNodes"];
    [self willChangeValueForKey:@"imageNames"];
    [self willChangeValueForKey:@"imagePaths"];
    [self willChangeValueForKey:@"videoPaths"];
    [self willChangeValueForKey:@"videoNames"];

    _rootNode = rootNode;
    [self didChangeValueForKey:@"videoPaths"];
    [self didChangeValueForKey:@"videoNames"];

    [self didChangeValueForKey:@"imagePaths"];
    [self didChangeValueForKey:@"imageNames"];
    [self didChangeValueForKey:@"resourceNodes"];
}

-(NSArray *)imageNames{
    NSArray *ret = [self.imagePaths valueForKeyPath:@"lastPathComponent"];
    return ret;
}

-(NSArray *)videoNames{
    NSArray *ret = [self.videoPaths valueForKeyPath:@"lastPathComponent"];
    return ret;
}

-(NSArray*)resourceNodes{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUResourceNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[IUResourceNode class]]) {
            if (evaluatedObject.type == IUResourceTypeImage ||
                evaluatedObject.type == IUResourceTypeVideo) {
                return YES;
            }
        }
        return NO;
    }];
    return [_rootNode.allChildren filteredArrayUsingPredicate:predicate];
}


- (IUResourceGroupNode *)imageNode{
    for(IUResourceGroupNode *child in _rootNode.children){
        if([child.name isEqualToString:@"Image"]){
            return child;
        }
    }
    return nil;
}

@end
