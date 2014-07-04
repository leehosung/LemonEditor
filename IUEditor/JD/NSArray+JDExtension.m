//
//  NSArray+JDExtension.m
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSArray+JDExtension.h"

@implementation NSArray (JDExtension)

- (id)firstObject{
    if (self.count == 0) {
        return nil;
    }
    return [self objectAtIndex:0];
}

- (id)firstObjectOfClass:(Class)aClass{
    for (id obj in self) {
        if ([obj isKindOfClass:aClass]) {
            return obj;
        }
    }
    return nil;
}

- (id)objectAtIndexOrNil:(NSUInteger)index{
    if (index >= [self count]) {
        return nil;
    }
    return [self objectAtIndex:index];
}

-(id)objectWithKey:(NSString*)key value:(id)value{
    for (id obj in self) {
        if ([[obj valueForKey:key] isEqualTo:value]) {
            return obj;
        }
    }
    return nil;
}

- (BOOL)containsString:(NSString*)string{
    for (NSString *str in self) {
        if ([str isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsPrefix:(NSString *)string{
    for (NSString *arrayStr in self) {
        NSString *prefix = [string substringWithRange:NSMakeRange(0, arrayStr.length)];
        if ([arrayStr isEqualToString:prefix]) {
            return YES;
        }
    }
    return NO;
}

-(id)objectBeforeObject:(id)obj{
    NSUInteger index = [self indexOfObject:obj];
    if (index == 0) {
        return nil;
    }
    else
        return [self objectAtIndex:index-1];
}

-(id)objectAfterObject:(id)obj{
    NSUInteger index = [self indexOfObject:obj];
    if (index == [self count]-1) {
        return nil;
    }
    else
        return [self objectAtIndex:index+1];
}

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

- (NSArray *)filteredArrayWithClass:(Class)class{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:class]) {
            return YES;
        }
        return NO;
    }];
    return [self filteredArrayUsingPredicate:predicate];
}

-(NSArray*)deepCopy{
    NSMutableArray *returnObject = [NSMutableArray array];
    for (id obj in self) {
        if ([obj respondsToSelector:@selector(deepCopy)]) {
            [returnObject addObject:[obj deepCopy]];
        }
        else if ([obj isKindOfClass:[NSMutableString class]]) {
            [returnObject addObject:[obj mutableCopy]];
        }
        else {
            [returnObject addObject:[obj copy]];
        }
    }
    return [returnObject copy];
}


@end


@implementation NSMutableArray (JDExtension)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}


-(NSArray*)deepCopy{
    NSMutableArray *returnObject = [NSMutableArray array];
    for (id obj in self) {
        if ([obj respondsToSelector:@selector(deepCopy)]) {
            [returnObject addObject:[obj deepCopy]];
        }
        else if ([obj isKindOfClass:[NSMutableString class]]) {
            [returnObject addObject:[obj mutableCopy]];
        }
        else {
            [returnObject addObject:[obj copy]];
        }
    }
    return returnObject;
}



@end
