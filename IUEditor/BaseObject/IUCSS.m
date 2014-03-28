//
//  IUCSS.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCSS.h"
#import "JDUIUtil.h"

NSString const  *CSSTypeToString[] = {
    [IUCSSTypePosition] = @"position",
    [IUCSSTypeBGColor] = @"background-color",
};

@implementation IUCSS{
    NSMutableDictionary *data;
}

-(id)init{
    self = [super init];
    data = [NSMutableDictionary dictionary];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:data forKey:@"data"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    data = [aDecoder decodeObjectForKey:@"data"];
    return self;
}

-(void)setStyle:(IUCSSType)type value:(id)value{
    if (data[@-1] == nil) {
        data[@-1] = [NSMutableDictionary dictionary];
    }
    data[@(-1)][CSSTypeToString[type]] = value;
}

-(void)setStyle:(IUCSSType)type value:(id)value width:(NSInteger)width{
    if (data[@(width)] == nil) {
        data[@(width)] = [NSMutableDictionary dictionary];
    }
    [self setStyle:type value:value];
}


-(NSDictionary*)tagDictionaryForDefault{
    return data[@(-1)];
}


-(NSDictionary*)tagDictionaryForWidth:(int)width{
    return data[@(width)];
}



@end
