//
//  NSCoder+JDExtension.m
//  IUEditor
//
//  Created by jd on 3/22/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSCoder+JDExtension.h"
#import "NSObject+JDExtension.h"

@implementation NSCoder (JDExtension)

-(void) encodeFromObject:(id)obj withProperties:(NSArray*)properties{
    for (JDProperty *property in properties) {
        if ([property isReadonly]) {
            continue;
        }
        else if ([property isInteger]){
            [self encodeInteger:[[obj valueForKey:property.name] integerValue] forKey:property.name];
        }
        else if ([property isFloat]){
            [self encodeFloat:[[obj valueForKey:property.name] floatValue] forKey:property.name];
        }
        else if ([property isDouble]){
            [self encodeDouble:[[obj valueForKey:property.name] doubleValue] forKey:property.name];
        }
        else if ([property isID]){
            [self encodeObject:[obj valueForKey:property.name] forKey:property.name];
        }
        else if ([property isSize]){
            [self encodeSize:[[obj valueForKey:property.name] sizeValue] forKey:property.name];
        }
        else if ([property isPoint]){
            [self encodePoint:[[obj valueForKey:property.name] pointValue] forKey:property.name];
        }
        else if ([property isRect]){
            [self encodeRect:[[obj valueForKey:property.name] rectValue] forKey:property.name];
        }
        else if ([property isChar]){
            [self encodeInt32:[[obj valueForKey:property.name] charValue] forKey:property.name];
        }

        else{
            NSAssert(0, @"");
        }
    }
}


-(void) decodeToObject:(id)obj withProperties:(NSArray*)properties{
    for (JDProperty *property in properties) {
        if ([property isReadonly]) {
            continue;
        }
        else if ([property isInteger]){
            [obj setValue:@([self decodeIntegerForKey:property.name]) forKey:property.name];
        }
        else if ([property isFloat]){
            [obj setValue:@([self decodeFloatForKey:property.name]) forKey:property.name];
        }
        else if ([property isDouble]){
            [obj setValue:@([self decodeDoubleForKey:property.name]) forKey:property.name];
        }
        else if ([property isChar]){
            [obj setValue:@([self decodeInt32ForKey:property.name]) forKey:property.name];
        }
        else if ([property isID]){
            id v = [self decodeObjectForKey:property.name];
            if (v) {
                [obj setValue:v forKey:property.name];
            }
        }
        else if ([property isSize]){
            [obj setValue:[NSValue valueWithSize:[self decodeSizeForKey:property.name]] forKey:property.name];
        }
        else if ([property isPoint]){
            [obj setValue:[NSValue valueWithPoint:[self decodePointForKey:property.name]] forKey:property.name];
        }
        else if ([property isRect]){
            [obj setValue:[NSValue valueWithRect:[self decodeRectForKey:property.name]] forKey:property.name];
        }
        else{
            NSAssert(0, @"");
        }
    }
}

@end
