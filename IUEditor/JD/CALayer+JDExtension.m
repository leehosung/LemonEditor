//
//  CALayer+JDExtension.m
//  Mango
//
//  Created by JD on 13. 8. 6..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "CALayer+JDExtension.h"
#import "JDUIUtil.h"

@implementation CALayer (JDExtension)
-(void)setCenter:(NSPoint)point{
    self.frame = NSRectModifyOrigin(self.frame, NSPointMake(point.x - self.frame.size.width/2,
                                                            point.y - self.frame.size.height/2));
}
- (void)bringSublayerToFront:(CALayer *)layer {
    CALayer *superlayer = layer.superlayer;
    [layer removeFromSuperlayer];
    [superlayer insertSublayer:layer atIndex:(unsigned)[superlayer.sublayers count]];
}

- (void)sendSublayerToBack:(CALayer *)layer {
    CALayer *superlayer = layer.superlayer;
    [layer removeFromSuperlayer];
    [superlayer insertSublayer:layer atIndex:0];
}


- (void)setFullFrameConstraint{
    CAConstraint *minX = [CAConstraint constraintWithAttribute:kCAConstraintMinX relativeTo:@"superlayer" attribute:kCAConstraintMinX];
    CAConstraint *maxX =[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintMaxX];
    CAConstraint *minY = [CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY];
    CAConstraint *maxY = [CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY];
    CAConstraint *width =[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth];
    CAConstraint *height =[CAConstraint constraintWithAttribute:kCAConstraintHeight relativeTo:@"superlayer" attribute:kCAConstraintHeight];
    
    [self setConstraints:[NSArray arrayWithObjects:minX, maxX,minY, maxY, width, height, nil]];
}

- (void)setBottomFrameContstraint{
    CAConstraint *minX = [CAConstraint constraintWithAttribute:kCAConstraintMinX relativeTo:@"superlayer" attribute:kCAConstraintMinX];
    CAConstraint *maxX =[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintMaxX];
    CAConstraint *minY = [CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY];
    CAConstraint *width =[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth];
    
    [self setConstraints:[NSArray arrayWithObjects:minX, maxX,minY, width, nil]];
}


-(id)addSubLayerFullFrame:(CALayer *)sublayer{
    self.layoutManager = [CAConstraintLayoutManager layoutManager];
    [sublayer setFullFrameConstraint];
    [self addSublayer:sublayer];
    return sublayer;
}

-(id)addSubLayerBottomFrame:(CALayer *)sublayer{
    self.layoutManager = [CAConstraintLayoutManager layoutManager];
    [sublayer setBottomFrameContstraint];
    [self addSublayer:sublayer];
    return sublayer;
}

-(id)insertSubLayerFullFrame:(CALayer *)sublayer below:(CALayer *)belowLayer{
    self.layoutManager = [CAConstraintLayoutManager layoutManager];
    [sublayer setFullFrameConstraint];
    [self insertSublayer:sublayer below:belowLayer];
    return sublayer;
    
}

- (void)disableAction{
    /*disable animation*/
    /*sublayer disable animation*/
    NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNull null], @"position",
                                       [NSNull null], @"bounds",
                                       [NSNull null], @"sublayers",
                                       [NSNull null], @"contents",
                                       nil];
    self.actions = newActions;
}
@end
