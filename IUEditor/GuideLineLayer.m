//
//  GuideLineLayer.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 31..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "GuideLineLayer.h"
#import "JDUIUtil.h"
#import "IUFrameDictionary.h"

@implementation GuideLineLayer

- (id)init{
    self = [super init];
    if (self){
        
        self.backgroundColor = [[NSColor clearColor] CGColor];
        
        path = [NSBezierPath bezierPath];
        
        [self setStrokeColor:[[NSColor keyboardFocusIndicatorColor] CGColor]];
        [self setLineWidth:1.0];
        [self setLineJoin:kCALineJoinMiter];
        [self setFillColor:[[NSColor clearColor] CGColor]];
        [self setLineDashPhase:3.0f];
        [self setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithFloat:5], nil]];
        
        
        [self disableAction];
    }
    return self;
}

- (void)clearPath{
    [path removeAllPoints];
    self.path = [path quartzPath];
}

- (void)drawLine:(NSArray *)array{
    [self clearPath];
    if(array.count <= 0){
        return;
    }
    
    for(PointLine *line in array){
        [path drawline:line.start end:line.end];
    }
    self.path = [path quartzPath];
}
@end
