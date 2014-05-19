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
    NSArray *array = @[@{@"width":@"600",@"count":@(2)}];
    self.responsiveSetting = array;
    self.defaultItemCount = 4;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_collectionVariable forKey:@"collectionVariable"];
    [aCoder encodeObject:_responsiveSetting forKey:@"responsiveSetting"];
    [aCoder encodeInteger:_responsiveSupport forKey:@"responsiveSupport"];
    [aCoder encodeInteger:_defaultItemCount forKey:@"defaultItemCount"];
}

-(BOOL)shouldEditText{
    return NO;
}
- (id)initWithIdentifierManager:(IUIdentifierManager *)identifierManager option:(NSDictionary *)option{
    self = [super initWithIdentifierManager:identifierManager option:option];
    NSArray *array = @[@{@"width":@"600",@"count":@(2)}];
    self.defaultItemCount = 4;
    self.responsiveSetting = array;
    return self;
}

- (void)setResponsiveSupport:(BOOL)responsiveSupport{
    _responsiveSupport = responsiveSupport;
    NSArray *array = @[@{@"width":@"600",@"count":@(2)}];
    self.responsiveSetting = array;
}

@end
