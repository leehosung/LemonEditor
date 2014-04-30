//
//  NSObject+JDExtension.m
//  IUEditor
//
//  Created by jd on 3/22/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSObject+JDExtension.h"
#import "NSString+JDExtension.h"
#import "NSDictionary+JDExtension.h"

@implementation JDProperty{
    BOOL    isReadonly;
    BOOL    isChar;
    BOOL    isInteger;
    BOOL    isFloat;
    BOOL    isDouble;
    BOOL    isPoint;
    BOOL    isSize;
    BOOL    isRect;
    BOOL    isID;
    NSString    *name;
}

-(id)initWithProperty:(objc_property_t)property{
    self = [super init];
    if (self) {
        name = [NSString stringWithUTF8String:property_getName(property)];
        
        char *readonly = property_copyAttributeValue(property, "R");
        if (readonly) {
            isReadonly = YES;
        }

        char *type = property_copyAttributeValue(property, "T");
        if (type[0] == 'c') {
            isChar = YES;
        }
        else if (type[0] == 'l' || type[0]=='i' || type[0]=='s' || type[0] == 'I') {
            isInteger = YES;
        }
        else if (type[0] == 'd') {
            isDouble = YES;
        }
        else if (type[0] == 'f') {
            isFloat = YES;
        }
        else if (strcmp(type, "^{CGRect={CGPoint=dd}{CGSize=dd}}") == 0) {
            isRect = YES;
        }
        else if (strcmp(type, "^{CGPoint=dd}") == 0) {
            isPoint = YES;
        }
        else if (strcmp(type, "^{CGSize=dd}") == 0) {
            isPoint = YES;
        }
        else if (strcmp(type, "T@")){
            isID = YES;
        }
        else {
            assert(0);
        }
    }
    return self;
}

-(NSString*)description{
    return [[super description] stringByAppendingFormat:@" %@",name];
}

-(NSString*)name{
    return name;
}
-(BOOL)isReadonly{
    return isReadonly;
}

-(BOOL)isFloat{
    return isFloat;
}

-(BOOL)isChar{
    return isChar;
}


-(BOOL)isDouble{
    return isDouble;
}

-(BOOL)isInteger{
    return isInteger;
}

-(BOOL)isPoint{
    return isPoint;
}

-(BOOL)isSize{
    return isSize;
}

-(BOOL)isRect{
    return isRect;
}



-(BOOL)isID{
    return isID;
}
@end

@implementation NSObject (JDExtension)

-(void)addObserver:(NSObject *)observer forKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context{
    for (NSString *keyPath in keyPaths) {
        [self addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

-(void)removeObserver:(NSObject *)observer forKeyPaths:(NSArray *)keyPaths context:(void *)context{
    for (NSString *keyPath in keyPaths) {
        [self removeObserver:observer forKeyPath:keyPath context:context];
    }
}

-(void)addObserver:(NSObject *)observer forKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options contexts:(NSArray*)contexts{
    for (NSString *keyPath in keyPaths) {
        if (contexts == nil) {
            [self addObserver:observer forKeyPath:keyPath options:options context:nil];
        }
        for (NSString *context in contexts) {
            [self addObserver:observer forKeyPath:keyPath options:options context:(void*)context];
        }
    }
}

-(void)removeObserver:(NSObject*)observer forKeyPaths:(NSArray*)keyPaths{
    for (NSString *keyPath in keyPaths) {
        [self removeObserver:observer forKeyPath:keyPath];
    }
}

-(void)removeObservers:(NSObject *)observer forKeyPath:(NSArray *)keyPaths{
    for (NSString *keyPath in keyPaths) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)_keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSString *selectorName;
    NSString *contextStr;
    
    NSMutableDictionary *mchange = [[NSDictionary dictionaryWithDictionary:change] mutableCopy];
    [mchange setObject:_keyPath forKey:kJDKeyPath];
    
    id contextID = (__bridge id)context;
    if ([contextID isKindOfClass:[NSString class]]) {
        contextStr = (__bridge NSString *)(context);
        [mchange setOrRemoveObject:contextStr forKey:kJDContext];
    }
    change = [NSDictionary dictionaryWithDictionary:mchange];
    
    NSString *keyPath = [_keyPath stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    SEL s;
    
    /*Execution order
     2) xxxDidChange:
     3) xxxDidChange:ofObject:
     5) xxxContextDidChange:
     6) xxxContextDidChange:ofObject
     */
    
    ///xxxDidChange:
    if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] == NO) {
        selectorName = [NSString stringWithFormat:@"%@DidChange:",keyPath];
    }
    else{
        selectorName = [NSString stringWithFormat:@"%@WillChange:",keyPath];
    }
    
    s = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:s  withObject:change];
#pragma clang diagnostic pop
    }
    
    ///xxxofObject:didChange:
    if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] == NO) {
        selectorName = [NSString stringWithFormat:@"%@OfObject:didChange:",keyPath];
    }
    else{
        selectorName = [NSString stringWithFormat:@"%@OfObject:willChange:",keyPath];
    }
    s = NSSelectorFromString(selectorName);
    
    
    if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:s  withObject:object withObject:change];
#pragma clang diagnostic pop
    }
    
    //context
    if (contextStr) {
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] == NO) {
            selectorName = [NSString stringWithFormat:@"%@ContextDidChange:",contextStr];
        }
        else{
            selectorName = [NSString stringWithFormat:@"%@ContextWillChange:",contextStr];
        }
        
        s = NSSelectorFromString(selectorName);
        if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:s  withObject:change];
#pragma clang diagnostic pop
        }
        
        //
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] == NO) {
            selectorName = [NSString stringWithFormat:@"%@ContextOfObject:didChange:",contextStr];
        }
        else{
            selectorName = [NSString stringWithFormat:@"%@ContextOfObject:willChange:",contextStr];
        }
        
        s = NSSelectorFromString(selectorName);
        if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:s  withObject:object withObject:change];
#pragma clang diagnostic pop
        }
        NSString *match = [[contextStr RGXMatchAllStringsWithPatten:@"@selector\\([^)]*\\)"] firstObject];
        if (match) {
            NSString *selectorName = [match substringFromIndex:10 toIndex:match.length-1];
            s = NSSelectorFromString(selectorName);
            if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:s withObject:change];
#pragma clang diagnostic pop
            }
        }
    }
}

+(NSArray*)classPedigreeTo:(Class)class{
    NSMutableArray *arr = [NSMutableArray array];
    Class currentClass = [self class];
    while (1) {
        [arr addObject:NSStringFromClass(currentClass)];
        if (currentClass == class) {
            break;
        }
        currentClass = [currentClass superclass];
    }
    return [NSArray arrayWithArray:arr];
}


+(NSArray*)properties{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        JDProperty *jdProperty = [[JDProperty alloc] initWithProperty:property];
        [rv addObject:jdProperty];
    }
    
    free(properties);
    
    return rv;
}

+(NSArray*)propertiesWithOutProperties:(NSArray*)array{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        JDProperty *jdProperty = [[JDProperty alloc] initWithProperty:property];
        if ([array containsObject:jdProperty.name ]) {
            continue;
        }
        [rv addObject:jdProperty];
    }
    
    free(properties);
    
    return rv;
}

@end
