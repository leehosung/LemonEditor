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

-(id)initWithManager:(IUIdentifierManager *)manager{
    self = [super initWithManager:manager];
    //create header
    _header = [[IUHeader alloc] initWithManager:manager];
    _header.htmlID = @"Header";
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


-(BOOL)hasX{
    return NO;
}

-(BOOL)hasY{
    return NO;
}

-(BOOL)hasWidth{
    return NO;
}

-(BOOL)hasHeight{
    return NO;
}

@end