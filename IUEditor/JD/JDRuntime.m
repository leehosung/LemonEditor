//
//  JDRuntime.m
//  Mango
//
//  Created by JD on 9/2/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "JDRuntime.h"

@implementation JDRuntime
+(NSString *) getPropertyType : (objc_property_t) property{
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
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
@end
