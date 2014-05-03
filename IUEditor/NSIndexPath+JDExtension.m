//
//  NSIndexPath+JDExtension.m
//  IUEditor
//
//  Created by jd on 5/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSIndexPath+JDExtension.h"

@implementation NSIndexPath (JDExtension)

+ (id)indexPathWithIndexPath:(NSIndexPath*)indexPath length:(NSUInteger)length{
    NSIndexPath *returnValue = [indexPath copy];
    NSInteger defaultLen = indexPath.length;
    while (defaultLen != length) {
        returnValue = [returnValue indexPathByRemovingLastIndex];
        defaultLen --;
    }
    return returnValue;
}

@end