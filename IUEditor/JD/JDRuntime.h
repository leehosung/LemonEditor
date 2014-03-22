//
//  JDRuntime.h
//  Mango
//
//  Created by JD on 9/2/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"


@interface JDRuntime : NSObject

+(NSArray*)properties:(Class)class;
+(NSArray*)propertiesWithoutReadonly:(Class)class;
+(NSString *)propertyType:(NSString*)name class:(Class)class;

@end