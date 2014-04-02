//
//  GuideLineLayer.h
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 31..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GuideLineLayer : CAShapeLayer{
    NSBezierPath *path;
}

- (void)clearPath;
- (void)drawLine:(NSArray *)array;

@end
