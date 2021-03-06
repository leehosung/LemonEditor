//
//  IUResponsiveSection.m
//  IUEditor
//
//  Created by jd on 4/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResponsiveSection.h"
#import "IUSection.h"

@implementation IUResponsiveSection

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
    IUSection *section = [[IUSection alloc] initWithCoder:aDecoder];
    
    [aDecoder decodeToObject:section withProperties:[[IUSection class] properties]];
    /*
     Version control
     
     since no IUResponsiveSection is allocated, check child and assign it to 'section'
     */
    for (IUBox *box in section.children) {
        box.parent = section;
    }
    return (IUResponsiveSection*)section;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUResponsiveSection class] properties]];
    
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
