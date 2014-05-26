//
//  IUResponsiveSection.m
//  IUEditor
//
//  Created by jd on 4/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResponsiveSection.h"

@implementation IUResponsiveSection

-(id)initWithIdentifierManager:(IUIdentifierManager*)manager option:(NSDictionary *)option{
    self = [super initWithIdentifierManager:manager option:option];
    if(self){
        [self.css setValue:@(0) forTag:IUCSSTagXUnit forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(0) forTag:IUCSSTagYUnit forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(1) forTag:IUCSSTagWidthUnit forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(0) forTag:IUCSSTagHeightUnit forWidth:IUCSSMaxViewPortWidth];
        
        [self.css setValue:@(100) forTag:IUCSSTagPercentWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(500) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(0) forTag:IUCSSTagX forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(0) forTag:IUCSSTagY forWidth:IUCSSMaxViewPortWidth];
        
        self.flow = YES;


    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUResponsiveSection class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUResponsiveSection class] properties]];
    
}


- (BOOL)enableXUserInput{
    return NO;
}
- (BOOL)enableYUserInput{
    return NO;
}
- (BOOL)enableWidthUserInput{
    return NO;
}

- (BOOL)flowChangeable{
    return NO;
}

@end
