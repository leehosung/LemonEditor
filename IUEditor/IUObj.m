//
//  IUObj.m
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUObj.h"
#import "IUCSS.h"
#import "NSObject+JDExtension.h"
#import "NSCoder+JDExtension.h"

@implementation IUObj
{
    IUCSS *css;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUObj class] properties]];
        css = [aDecoder decodeObjectForKey:@"css"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeFromObject:self withProperties:[[IUObj class] properties]];
    [aCoder encodeObject:css forKey:@"css"];
}

-(id)initWithDefaultSetting{
    self = [super init];{
        css = [[IUCSS alloc] init];
    }
    return self;
}

-(NSString*) outputCSS{
    return @"outputCSS";
}

-(NSString*) outputHTML{
    return @"outputHTML";
}


@end
