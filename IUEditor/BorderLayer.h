//
//  borderLayer.h
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 26..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface BorderLayer : CAShapeLayer{
    NSString *IUID;
}

- (id)initWithIUID:(NSString *)aIUID withFrame:(NSRect)frame;
- (NSString *)iuID;

@end
