//
//  PointTextLayer.h
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 27..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef enum{
    PointTextTypeOrigin,
    PointTextTypeSize,
}PointTextType;

@interface PointTextLayer : CATextLayer{
    PointTextType type;
    NSString *IUID;
    NSRect iuFrame;
}

- (id)initWithIUID:(NSString *)aIUID withFrame:(NSRect)frame type:(PointTextType)aType;
- (void)updateFrame:(NSRect)frame;
- (NSString *)iuID;


@end
