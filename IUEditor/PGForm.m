//
//  PGForm.m
//  IUEditor
//
//  Created by jd on 5/7/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "PGForm.h"

@implementation PGForm


-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[PGForm class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[PGForm class] properties]];
    
}

- (id)copyWithZone:(NSZone *)zone{
    PGForm *iu = [super copyWithZone:zone];
    iu.target = [_target copy];
    return iu;
}

- (BOOL)hasText{
    return NO;
}
@end
    