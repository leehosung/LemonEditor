//
//  LMGeneralObject.m
//  IUEditor
//
//  Created by JD on 3/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMGeneralObject.h"

@implementation LMGeneralObject{
    NSMutableDictionary *_dict;
}

-(id)init{
    self = [super init];
    _dict = [NSMutableDictionary dictionary];
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    [_dict setObject:value forKey:key];
}

-(id)valueForUndefinedKey:(NSString *)key{
    return [_dict objectForKey:key];
}
@end
