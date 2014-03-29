//
//  NSObject+JDExtension.h
//  IUEditor
//
//  Created by jd on 3/22/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"

#define kJDKeyPath @"JDKeyPath"
#define kJDContext @"JDContext"


@interface JDProperty : NSObject

-(id)initWithProperty:(objc_property_t)property;

-(NSString*)name;
-(BOOL)isReadonly;
-(BOOL)isFloat;
-(BOOL)isDouble;
-(BOOL)isInteger;
-(BOOL)isChar;
-(BOOL)isPoint;
-(BOOL)isSize;
-(BOOL)isRect;
-(BOOL)isID;
@end


@interface NSObject (JDExtension)


-(void)addObserver:(NSObject *)observer forKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context;

-(void)removeObserver:(NSObject*)observer forKeyPaths:(NSArray*)keyPaths;

- (void)observeValueForKeyPath:(NSString *)_keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
-(void)removeObserver:(NSObject *)observer forKeyPaths:(NSArray *)keyPaths context:(void *)context;
-(void)addObserver:(NSObject *)observer forKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options contexts:(NSArray*)contexts;
+(NSArray*)classPedigreeTo:(Class)class;
+(NSArray*)properties;
@end
