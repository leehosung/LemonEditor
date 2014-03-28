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
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_children forKey:@"children"];
}

-(id)init{
    self = [super init];
    _children = [NSMutableArray array];
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
    [(NSMutableArray*)_children addObject:node];
}

@end
