//
//  IUNode.m
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUNode.h"

@implementation IUNode
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _children = [[aDecoder decodeObjectForKey:@"children"] mutableCopy];
        for (IUNode *node in _children) {
            [node addObserver:self forKeyPath:@"allChildren" options:0 context:nil];
        }
    }
    return self;
}

-(void)allChildrenDidChange:(NSDictionary*)change{
    [self willChangeValueForKey:@"allChildren"];
    [self didChangeValueForKey:@"allChildren"];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_children forKey:@"children"];
}

-(id)init{
    self = [super init];
    if (self) {
        _children = [NSMutableArray array];
    }
    return self;
}

-(NSArray*)allChildren{
    NSMutableArray  *array = [NSMutableArray array];
    for (IUNode *node in _children) {
        [array addObject:node];
        [array addObjectsFromArray:node.allChildren];
    }
    return [array copy];
}

-(void)addNode:(IUNode*)node{
    [self willChangeValueForKey:@"allChildren"];
    [(NSMutableArray*)_children addObject:node];
    [node addObserver:self forKeyPath:@"allChildren" options:0 context:nil];
    [self didChangeValueForKey:@"allChildren"];
}

-(NSString*)description{
    return [[super description] stringByAppendingString:self.name];
}
@end
