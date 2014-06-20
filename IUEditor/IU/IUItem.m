//
//  IUItem.m
//  IUEditor
//
//  Created by jd on 4/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUItem.h"
#import "IUCarousel.h"
#import "IUTransition.h"

@implementation IUItem
- (BOOL)hasX{
    return NO;
}

- (BOOL)hasY{
    return NO;
}
- (BOOL)hasWidth{
    return NO;
}
- (BOOL)hasHeight{
    return NO;
}

//자기 자신대신 parent를 옮기는 경우
- (BOOL)shouldMoveParent{
    return YES;
}

- (BOOL)canChangePositionType{
    return NO;
}

@end
