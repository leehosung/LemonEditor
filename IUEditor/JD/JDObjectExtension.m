//
//  JDObjectExtension.m
//  Mango
//
//  Created by JD on 13. 3. 31..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDObjectExtension.h"
#import "NSDictionary+JDExtension.h"
#import "NSString+JDExtension.h"


@implementation NSObject(JDObjectExtension)
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
     1) xxxDidChange
     2) xxxDidChange:
     3) xxxDidChange:ofObject
     4) xxxContextDidChange
     5) xxxContextDidChange:
     6) xxxContextDidChange:ofObject
     */

    //xxxDidChange
    if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
        selectorName = [NSString stringWithFormat:@"%@DidChange",keyPath];
    }
    else{
        selectorName = [NSString stringWithFormat:@"%@WillChange",keyPath];
    }
    
    s = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:s];
#pragma clang diagnostic pop
    }

    ///xxxDidChange:
    if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
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
    if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
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
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
            selectorName = [NSString stringWithFormat:@"%@ContextDidChange",contextStr];
        }
        else{
            selectorName = [NSString stringWithFormat:@"%@ContextWillChange",contextStr];
        }
        
        s = NSSelectorFromString(selectorName);
        if ([self respondsToSelector:s]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:s];
#pragma clang diagnostic pop
        }
        
        //
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
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
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue] != YES) {
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


@end
