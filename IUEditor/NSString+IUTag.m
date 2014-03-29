//
//  NSString+IUTag.m
//  IUEditor
//
//  Created by jd on 3/30/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSString+IUTag.h"

@implementation NSString (IUTag)
-(NSString*)pixelString{
    return [self stringByAppendingString:@"px"];
}
-(NSString*)percentString{
    return [self stringByAppendingString:@"%"];
}
@end
