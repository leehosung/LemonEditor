//
//  IUCollection.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCollection.h"

@implementation IUCollection

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _collectionVariable = [aDecoder decodeObjectForKey:@"collectionVariable"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_collectionVariable forKey:@"collectionVariable"];
}
@end
