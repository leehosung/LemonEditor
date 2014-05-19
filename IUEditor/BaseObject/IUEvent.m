//
//  IUEvent.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 25..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUEvent.h"

@interface IUEvent()

@end

@implementation IUEvent

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IUEvent *event = [[self class] allocWithZone:zone];
    NSArray *properties = [[self class] properties];
    for (JDProperty *property in properties) {
        id value = [self valueForKey:property.name];
        if (property.isID) {
            [self setValue:[value copy] forKey:property.name];
        }
        else {
            [self setValue:value forKey:property.name];
        }
    }
    return event;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeFromObject:self withProperties:[IUEvent properties]];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        [aDecoder decodeToObject:self withProperties:[IUEvent properties]];
    }
    return self;
}

- (NSString *)findVariable:(NSString *)equation{
    
    NSString *trimmedEquation = [equation stringByTrim];
    NSCharacterSet *parsingSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSArray *component = [trimmedEquation componentsSeparatedByCharactersInSet:parsingSet];
    
    return component[0];
}

- (void)setEqVisible:(NSString *)eqVisible{
    _eqVisible = eqVisible;
    _eqVisibleVariable = [self findVariable:eqVisible];
}

- (void)setEqFrame:(NSString *)eqFrame{
    _eqFrame = eqFrame;
    _eqFrameVariable = [self findVariable:eqFrame];
}

@end
