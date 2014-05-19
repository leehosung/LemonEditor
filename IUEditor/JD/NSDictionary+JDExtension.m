//
//  NSDictionary+JDExtension.m
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSDictionary+JDExtension.h"
#import "JDLogUtil.h"

@implementation NSDictionary (JDExtension)

-(BOOL)writeAsJSONFile:(NSString *)path atomically:(BOOL)atomically{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        JDErrorLog( @"WriteAsJsonFile : %@", error.localizedFailureReason);
        return NO;
    }
    return [data writeToFile:path atomically:atomically];
}

+(NSDictionary*)dictionaryWithJSONContentsOfFile:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        JDErrorLog( @"dictionaryWithJsonContentsOfFile : %@", error.localizedFailureReason);
        return nil;
    }
    return dict;
}

-(NSMutableDictionary*)deepCopy{
    NSMutableDictionary *returnObject = [NSMutableDictionary dictionary];
    for (id key in self) {
        id value = self[key];
        if ([value respondsToSelector:@selector(deepCopy)]) {
            returnObject[key] = [value deepCopy];
        }
        else if ([value isKindOfClass:[NSMutableString class]]) {
            returnObject[key] = [value mutableCopy];
        }
        else {
            returnObject[key] = [value copy];
        }
    }
    return [returnObject copy];
}


@end

@implementation NSMutableDictionary (JDExtension)

- (void)setOrRemoveObject:(id)object forKey:(id)key{
    if (object == nil) {
        [self removeObjectForKey:key];
        return;
    }
    [self setObject:object forKey:key];
}

-(void)overwrite:(NSDictionary *)overwriteDict{
    for (id key in overwriteDict) {
        if ([self objectForKey:key] != nil) {
            if ([[self objectForKey:key] isKindOfClass:[NSDictionary class]] &&
                [[overwriteDict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *subDict = [[self objectForKey:key] mutableCopy];
                [subDict overwrite:[overwriteDict objectForKey:key]];
                [self setObject:subDict forKey:key];
            }
            else{
                [self setObject:[overwriteDict objectForKey:key] forKey:key];
            }
        }
        else{
            [self setObject:[overwriteDict objectForKey:key] forKey:key];
        }
    }
    return;
}

-(NSMutableDictionary*)deepCopy{
    NSMutableDictionary *returnObject = [NSMutableDictionary dictionary];
    for (id key in self) {
        id value = self[key];
        if ([value respondsToSelector:@selector(deepCopy)]) {
            returnObject[key] = [value deepCopy];
        }
        else if ([value isKindOfClass:[NSMutableString class]]) {
            returnObject[key] = [value mutableCopy];
        }
        else {
            returnObject[key] = [value copy];
        }
    }
    return returnObject;

}


@end