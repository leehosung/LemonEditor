//
//  IURender.m
//  IUEditor
//
//  Created by jd on 4/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUImport.h"
#import "IUBox.h"


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

-(BOOL)shouldEditText{
    return NO;
}


-(BOOL)addIU:(IUBox *)iu error:(NSError**)error{
    BOOL retValue = [super addIU:iu error:error];
    
    IUClass *classIU = (IUClass *)iu;
    [classIU.referenceArray addObject:self];
    
    return retValue;
}


@end
