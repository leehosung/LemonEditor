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
        [aDecoder decodeToObject:self ]
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self ofProperties:[IUObj properties]];
}

-(id)initWithDefaultSetting{
    self = [super init];
    return self;
}

@end
