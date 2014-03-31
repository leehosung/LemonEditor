//
//  IUCSS.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCSS.h"
#import "JDUIUtil.h"

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

-(void)putTag:(IUCSSTag)type value:(id)value{
    [self setTag:type value:value width:IUCSSTagDictionaryDefaultWidth];
    if (data[@IUCSSTagDictionaryDefaultWidth] == nil) {
        data[@IUCSSTagDictionaryDefaultWidth] = [NSMutableDictionary dictionary];
    }
    [self setTag:type value:value width:IUCSSTagDictionaryDefaultWidth];
}

-(void)removeTag:(IUCSSTag)type{
    [data[@IUCSSTagDictionaryDefaultWidth] removeObjectForKey:type];
}

-(void)setTag:(IUCSSTag)type value:(id)value width:(NSInteger)width{
    if (data[@(width)] == nil) {
        data[@(width)] = [NSMutableDictionary dictionary];
    }
    data[@(width)][type] = value;
}


-(NSDictionary*)tagDictionaryForWidth:(int)width{
    return data[@(width)];
}


@end
