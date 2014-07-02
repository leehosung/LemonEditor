//
//  SelectionBorderLayer.h
//  IUEditor
//
//  Created by test on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SelectionBorderLayer : CAShapeLayer{
    NSString *IUID;
}

- (id)initWithIUID:(NSString *)aIUID withFrame:(NSRect)frame;
- (NSString *)iuID;


@end
