//
//  IUNode.m
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUNode.h"
#import "IUGroupNode.h"

@implementation IUNode
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _parent = [aDecoder decodeObjectForKey:@"parent"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_parent forKey:@"parent"];
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString*)description{
    return [[super description] stringByAppendingString:self.name];
}

-(BOOL)isLeaf{
    return YES;
}

- (IUGroupNode*)rootNode{
    if (self.parent == nil) {
        return (IUGroupNode*)self;
    }
    return (IUGroupNode*)(self.parent).rootNode;
}
@end
