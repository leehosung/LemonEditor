//
//  IUCollection.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCollection.h"

@implementation IUCollection

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _collectionVariable = [aDecoder decodeObjectForKey:@"collectionVariable"];
    _responsiveSetting = [aDecoder decodeObjectForKey:@"responsiveSetting"];
    _responsiveSupport = [aDecoder decodeIntegerForKey:@"responsiveSupport"];
    _defaultItemCount = [aDecoder decodeIntegerForKey:@"defaultItemCount"];
    
    //template of array
    //NSArray *array = @[@{@"width":@"600",@"count":@(2)}];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_collectionVariable forKey:@"collectionVariable"];
    [aCoder encodeObject:_responsiveSetting forKey:@"responsiveSetting"];
    [aCoder encodeInteger:_responsiveSupport forKey:@"responsiveSupport"];
    [aCoder encodeInteger:_defaultItemCount forKey:@"defaultItemCount"];
}

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    self.defaultItemCount = 4;
    self.responsiveSetting = [NSArray array];
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IUCollection *iu = [super copyWithZone:zone];
    iu.collectionVariable = [_collectionVariable copy];
    iu.responsiveSupport = _responsiveSupport;
    iu.responsiveSetting = [_responsiveSetting copy];
    iu.defaultItemCount = _defaultItemCount;
    return iu;
}

- (void)setResponsiveSupport:(BOOL)responsiveSupport{
    _responsiveSupport = responsiveSupport;
    self.responsiveSetting = [NSArray array];
}

@end
