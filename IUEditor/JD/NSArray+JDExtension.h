//
//  NSArray+JDExtension.h
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JDExtension)

- (id)firstObject;
- (id)firstObjectOfClass:(Class)aClass;

- (id)objectAtIndexOrNil:(NSUInteger)index;
- (BOOL)containsString:(NSString*)string;
- (BOOL)containsPrefix:(NSString *)string;

- (id)objectBeforeObject:(id)obj;
- (id)objectAfterObject:(id)obj;
- (id)objectWithKey:(NSString*)key value:(id)value;

- (NSArray *)reversedArray;
- (NSArray *)filteredArrayWithClass:(Class)class;
- (NSArray *)deepCopy;
@end



@interface NSMutableArray (JDExtension)

- (void)reverse;
-(NSMutableArray *)deepCopy;
@end