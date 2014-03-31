//
//  IUPage.m
//  IUEditor
//
//  Created by jd on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPage.h"

@implementation IUPage

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[IUPage properties]];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[IUPage properties]];
    return self;
}

- (id)initWithProject:(IUProject *)project setting:(NSDictionary *)setting{
    self = [super initWithProject:project setting:setting];
    
    //add some iu
    IUObj *obj = [[IUObj alloc] initWithProject:project setting:setting];
    obj.htmlID = @"qwerq";
    obj.name = @"sample object";
    [self addIU:obj error:nil];
    
    [self.css removeTag:IUCSSTagX];
    [self.css removeTag:IUCSSTagY];
    [self.css removeTag:IUCSSTagWidth];
    [self.css removeTag:IUCSSTagHeight];

    return self;
}

@end