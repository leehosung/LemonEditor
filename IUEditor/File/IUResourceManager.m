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

#if 0
-(NSString*)relativePathForResource:(NSString*)name{
    /*
    IUResourceFile *node = (IUResourceFile*)[self nodeWithName:name];
    return node.relativePath;
     */
}

-(NSString*)absolutePathForResource:(NSString*)name{
    //FIXME:a
    /*
    IUResourceFile *node = (IUResourceFile*)[self nodeWithName:name];
    return node.absolutePath;
     */
}

-(IUResourceFile*)insertResourceWithData:(NSData*)data type:(IUResourceType)type{
    assert(0);
    return nil;
}


-(IUResourceFile*)insertResourceWithContentOfPath:(NSString*)path type:(IUResourceType)type{
    
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
    
    IUResourceGroup *parent = (IUResourceGroup*)[self nodeWithName:groupName];
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
    
    IUResourceFile *resourceNode = [[IUResourceFile alloc] initWithName:[path lastPathComponent] type:type];

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
        if ([evaluatedObject isKindOfClass:[IUResourceFile class]]) {
            if (((IUResourceFile*)evaluatedObject).type == IUResourceTypeImage) {
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
        if ([evaluatedObject isKindOfClass:[IUResourceFile class]]) {
            if (((IUResourceFile*)evaluatedObject).type == IUResourceTypeVideo) {
                return YES;
            }
        }
        return NO;
    }];
    NSArray *imageNodes = [nodes filteredArrayUsingPredicate:predicate];
    NSArray *ret = [imageNodes valueForKeyPath:@"relativePath"];
    return ret;
}

-(void)setRootNode:(IUResourceGroup *)rootNode{
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
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUResourceFile* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[IUResourceFile class]]) {
            if (evaluatedObject.type == IUResourceTypeImage ||
                evaluatedObject.type == IUResourceTypeVideo) {
                return YES;
            }
        }
        return NO;
    }];
    return [_rootNode.allChildren filteredArrayUsingPredicate:predicate];
}


- (IUResourceGroup *)imageNode{
    for(IUResourceGroup *child in _rootNode.children){
        if([child.name isEqualToString:@"Image"]){
            return child;
        }
    }
    return nil;
}

- (IUResourceGroup *)videoNode{
    for(IUResourceGroup *child in _rootNode.children){
        if([child.name isEqualToString:@"Video"]){
            return child;
        }
    }
    return nil;
}

- (IUResourceGroup *)jsNode{
    for(IUResourceGroup *child in _rootNode.children){
        if([child.name isEqualToString:@"JS"]){
            return child;
        }
    }
    return nil;
}

- (IUResourceGroup *)cssNode{
    for(IUResourceGroup *child in _rootNode.children){
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

-(IUResourceFile*)imageResourceNodeOfName:(NSString*)imageName{
    NSArray *nodes = _rootNode.allChildren;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUNode* evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[IUResourceFile class]]) {
            if (((IUResourceFile*)evaluatedObject).type == IUResourceTypeImage) {
                if ([((IUResourceFile*)evaluatedObject).name isEqualToString:imageName]) {
                    return YES;
                }
            }
        }
        return NO;
    }];
    NSArray *imageNodes = [nodes filteredArrayUsingPredicate:predicate];
    return [imageNodes firstObject];
}
#endif

@end
