//
//  IUObj.m
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUObj.h"
#import "NSObject+JDExtension.h"
#import "NSCoder+JDExtension.h"

@implementation IUObj{
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUObj class] properties]];
        _css = [aDecoder decodeObjectForKey:@"css"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeFromObject:self withProperties:[[IUObj class] properties]];
    [aCoder encodeObject:self.css forKey:@"css"];
}

-(id)initWithSetting:(NSDictionary*)setting{
    self = [super init];{
        _children = [NSMutableArray array];
        _css = [[IUCSS alloc] init];
        [_css setStyle:IUCSSTypePosition value:@"relative"];
    }
    return self;
}


-(id)init{
    assert(0);
    return nil;
}

-(NSMutableArray*)allChildren{
    if (self.children) {
        NSMutableArray *array = [NSMutableArray array];
        for (IUObj *iu in self.children) {
            [array addObject:iu];
            [array addObjectsFromArray:iu.allChildren];
        }
        return array;
    }
    return nil;
}

-(NSDictionary*)HTMLAtributes{
    NSArray *classPedigree = [[self class] classPedigreeTo:[IUObj class]];
    NSMutableString *className = [NSMutableString stringWithString:@"'"];
    for (NSString *str in classPedigree) {
        [className appendString:str];
        [className appendString:@" "];
    }
    [className appendString:@"'"];
    return @{@"class":className, @"id":self.htmlID};
}

-(NSDictionary*)CSSAttributesForDefault{
    return [_css tagDictionaryForWidth:-1];
}

-(NSDictionary*)CSSAttributesForWidth:(NSUInteger)width{
    return [_css tagDictionaryForWidth:width];
}


@end
