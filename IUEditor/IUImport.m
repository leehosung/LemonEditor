//
//  IURender.m
//  IUEditor
//
//  Created by jd on 4/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUImport.h"

@implementation IUImport

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _prototypeClass = [aDecoder decodeObjectForKey:@"_prototypeClass"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_prototypeClass forKey:@"_prototypeClass"];
}

- (void)setPrototypeClass:(IUClass *)prototypeClass{
    [self removeIU:_prototypeClass];
    _prototypeClass = prototypeClass;
    if (_prototypeClass) {
        [self addIU:_prototypeClass error:nil];
    }
}





@end
