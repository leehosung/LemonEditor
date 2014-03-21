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

+(NSString*) getPropertyType : (objc_property_t) property;

@end
