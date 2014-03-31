//
//  IUMaster.m
//  IUEditor
//
//  Created by jd on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUMaster.h"

@interface IUMaster()
@property NSMutableArray    *bodyParts;
@end


@implementation IUMaster

-(id)initWithProject:(IUProject *)project setting:(NSDictionary *)setting{
    self = [super initWithProject:project setting:setting];
    //create header
    _header = [[IUHeader alloc] initWithProject:project setting:setting];
    _header.name = @"Header";
    _header.htmlID = [project requestNewID:[IUHeader class]];
    [self addIU:_header error:nil];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[IUMaster properties]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[IUMaster properties]];
}


@end