//
//  IUDirectoryNode.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUFileGroup.h"

@implementation IUFileGroup

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
        _name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}


-(id)initWithName:(NSString*)name{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

-(NSString*)name{
    return _name;
}

@end
