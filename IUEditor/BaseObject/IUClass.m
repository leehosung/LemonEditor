//
//  IUClass.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUClass.h"
#import <objc/runtime.h>

NSArray* GetPropertyList(Class a){
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(a, &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;

}


@implementation IUClass

-(id)instatiate{
    return self;
}

// Save + Load
-(void)importFromDict:(NSDictionary*)dict{
    return;
}

-(NSMutableDictionary*)exportAsDict{
    return [NSMutableDictionary dictionary];
}

+(NSArray*)classPedigree{
    NSMutableArray *arr = [NSMutableArray array];
    Class currentClass = [self class];
    while (1) {
        if (currentClass == [IUClass class]) {
            break;
        }
        [arr addObject:NSStringFromClass(currentClass)];
        currentClass = [currentClass superclass];
    }
    return [NSArray arrayWithArray:arr];
}

@end
