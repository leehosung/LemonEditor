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
    
    if(type == IUResourceTypeNone){
        return nil;
    }
    
    NSString *groupName;
    
    switch (type) {
        case IUResourceTypeCSS:
            groupName=@"CSS";
            break;
        case IUResourceTypeJS:
            groupName=@"JS";
            break;
        case IUResourceTypeVideo:{
            groupName=@"Video";
            break;
        }
        case IUResourceTypeImage:{
            groupName=@"Image";
            break;
        }
        default: assert(0);  break;
    }
    
    IUResourceGroupNode *parent = (IUResourceGroupNode*)[self nodeWithName:groupName];
    NSString *fileName = [path lastPathComponent];
    if([parent containName:fileName]){
        return nil;
    }
    
    [self willChangeValueForKey:@"resourceNodes"];
    switch (type) {
        case IUResourceTypeCSS:
            break;
        case IUResourceTypeJS:
            break;
        case IUResourceTypeVideo:{
            [self willChangeValueForKey:@"videoNames"];
            [self willChangeValueForKey:@"videoPaths"];
            break;
        }
        case IUResourceTypeImage:{
            [self willChangeValueForKey:@"imageNames"];
            [self willChangeValueForKey:@"imagePaths"];
            break;
            
        }
        default: assert(0);  break;
    }
    
    IUResourceNode *resourceNode = [[IUResourceNode alloc] initWithName:[path lastPathComponent] type:type];

    [parent addResourceNode:resourceNode path:path];
    
    //notify didchange
    switch (type) {
        case IUResourceTypeImage:
            [self didChangeValueForKey:@"imagePaths"];
            [self didChangeValueForKey:@"imageNames"];
            break;
        case IUResourceTypeVideo:
            [self didChangeValueForKey:@"videoPaths"];
            [self didChangeValueForKey:@"videoNames"];
            break;
            
        default:
            break;
    }
    [self didChangeValueForKey:@"resourceNodes"];
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

- (IUResourceGroupNode *)videoNode{
    for(IUResourceGroupNode *child in _rootNode.children){
        if([child.name isEqualToString:@"Video"]){
            return child;
        }
    }
    return nil;
}

- (IUResourceGroupNode *)jsNode{
    for(IUResourceGroupNode *child in _rootNode.children){
        if([child.name isEqualToString:@"JS"]){
            return child;
        }
    }
    return nil;
}

- (IUResourceGroupNode *)cssNode{
    for(IUResourceGroupNode *child in _rootNode.children){
        if([child.name isEqualToString:@"CSS"]){
            return child;
        }
    }
    return nil;
}

-(IUResourceType)resourceType:(NSString *)anExtension{
    
    NSString *extension = [anExtension lowercaseString];
    
    NSArray *imageExtensions = @[@"jpg", @"png", @"gif", @"jpeg", @"bmp", @"tiff"];
    NSArray *videoExtensions = @[@"mp4"];
    if([imageExtensions containsObject:extension]){
        return IUResourceTypeImage;
    }
    else if([videoExtensions containsObject:extension]){
        return IUResourceTypeVideo;
    }
    else if([extension isEqualToString:@"js"]){
        return IUResourceTypeJS;
    }
    else if([extension isEqualToString:@"css"]){
        return IUResourceTypeCSS;
    }
    return IUResourceTypeNone;
}

-(IUResourceNode*)imageResourceNodeOfName:(NSString*)imageName{
    NSArray *nodes = _rootNode.allChildren;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[IUResourceNode class]]) {
            if (((IUResourceNode*)evaluatedObject).type == IUResourceTypeImage) {
                if ([((IUResourceNode*)evaluatedObject).name isEqualToString:imageName]) {
                    return YES;
                }
            }
        }
        return NO;
    }];
    NSArray *imageNodes = [nodes filteredArrayUsingPredicate:predicate];
    return [imageNodes firstObject];
}

@end
