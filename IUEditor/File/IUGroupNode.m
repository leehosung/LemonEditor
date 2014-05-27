//
//  IUGroupNode.m
//  IUEditor
//
//  Created by JD on 4/6/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUGroupNode.h"
#import "IUProject.h"

@implementation IUGroupNode{
    NSMutableArray *_children;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _children = [[aDecoder decodeObjectForKey:@"children"] mutableCopy];
        for (IUNode *node in _children) {
            [node addObserver:self forKeyPath:@"allChildren" options:0 context:nil];
        }
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
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
    for (IUGroupNode *node in _children) {
        [array addObject:node];
        if ([node isKindOfClass:[IUGroupNode class]]) {
            [array addObjectsFromArray:node.allChildren];
        }
    }
    return [array copy];
}

-(void)addNode:(IUNode*)node{
    [self willChangeValueForKey:@"children"];
    [_children addObject:node];
    node.parent = self;
    [self didChangeValueForKey:@"children"];
}

-(void)removeNode:(IUNode*)node{
    [self willChangeValueForKey:@"children"];
    [_children removeObject:node];
    [self didChangeValueForKey:@"children"];

}

-(void)removeAllNode{
    [self willChangeValueForKey:@"children"];
    [_children removeAllObjects];
    [self didChangeValueForKey:@"children"];

}

-(BOOL)containName:(NSString *)name{
    for(IUNode *child in _children){
        if([child.name isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}


-(NSArray*)children{
    return [_children copy];
}

-(BOOL)isLeaf{
    return NO;
}

- (IUNode*)nodeWithName:(NSString*)name{
    if ([self.name isEqualToString:name]) {
        return self;
    }
    for (IUNode *node in _children) {
        IUNode *retNode = [node nodeWithName:name];
        if (retNode) {
            return retNode;
        }
    }
    return nil;
}
@end
