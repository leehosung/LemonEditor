//
//  IUBackground.m
//  IUEditor
//
//  Created by jd on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBackground.h"

@interface IUBackground()
@property NSMutableArray    *bodyParts;
@end


@implementation IUBackground

-(id)initWithIdentifierManager:(IUIdentifierManager *)manager option:(NSDictionary*)option{
    self = [super initWithIdentifierManager:manager option:option];
    //create header
    NSNumber *num = [option objectForKey:kIUBackgroundOptionEmpty];
    if ([num intValue] == NO) {
        _header = [[IUHeader alloc] initWithIdentifierManager:manager option:option];
        _header.htmlID = @"Header";
        [self addIU:_header error:nil];
    }
    return self;
}

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    NSNumber *num = [options objectForKey:kIUBackgroundOptionEmpty];
    if ([num intValue] == NO) {
        _header = [[IUHeader alloc] initWithProject:project options:nil];
        _header.htmlID = @"Header";
        [self addIU:_header error:nil];
    }
    assert(self.children);
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[IUBackground properties]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[IUBackground properties]];
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