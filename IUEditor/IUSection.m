//
//  IUResponsiveSection.m
//  IUEditor
//
//  Created by jd on 4/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUSection.h"

@implementation IUSection

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.css setValue:@(0) forTag:IUCSSTagXUnit forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(0) forTag:IUCSSTagYUnit forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(1) forTag:IUCSSTagWidthUnit forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(0) forTag:IUCSSTagHeightUnit forWidth:IUCSSMaxViewPortWidth];
        
        [self.css setValue:@(100) forTag:IUCSSTagPercentWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(500) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(0) forTag:IUCSSTagX forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(0) forTag:IUCSSTagY forWidth:IUCSSMaxViewPortWidth];
        
        self.positionType = IUPositionTypeRelative;
     }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUSection class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUSection class] properties]];
    
}


- (BOOL)canChangeXByUserInput{
    return NO;
}
- (BOOL)canChangeYByUserInput{
    return NO;
}
- (BOOL)canChangeWidthByUserInput{
    return NO;
}

- (BOOL)canChangePositionType{
    return NO;
}

@end
