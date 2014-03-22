//
//  JDRuntime.m
//  Mango
//
//  Created by JD on 9/2/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "JDRuntime.h"

@implementation JDRuntime

#if 0
+(NSArray*)properties:(Class)class{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        JDProperty  *jdProperty = [[JDProperty alloc] init];
        jdProperty.name = [NSString stringWithUTF8String:property_getName(property)];
        
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

+(NSArray*)propertiesWithoutReadonly:(Class)class{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        if ([self isReadonlyProperty:property class:class] == NO) {
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            [rv addObject:name];
        }
    }
    
    free(properties);
    
    return rv;
}


+(BOOL)isReadonlyProperty:(objc_property_t)p class:(Class)class{
    const char *attributes = property_getAttributes(p);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    
    char *state = buffer;
    char *attribute;

    strsep(&state, ","); //remove first
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (strcmp(attribute, "R") == 0) {
            return YES;
        }
    }
    return NO;
}

+(NSString *)propertyType :(NSString*)name class:(Class)class{
    objc_property_t p = class_getProperty(class, [name UTF8String]);
    return [self propertyType:p];
}


+(NSString *)propertyType : (objc_property_t) property{
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return [NSString stringWithUTF8String:[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes]];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return @"id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return [NSString stringWithUTF8String:[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes]];
        }
    }
    return @"";
}

#endif
@end
