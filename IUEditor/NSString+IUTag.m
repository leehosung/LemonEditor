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

-(BOOL)isFrameTag{
    if ([self isSameTag:IUCSSTagWidth] || [self isSameTag:IUCSSTagHeight] || [self isSameTag:IUCSSTagPercentHeight] || [self isSameTag:IUCSSTagPercentWidth]
        || [self isSameTag:IUCSSTagX] || [self isSameTag:IUCSSTagPercentX] || [self isSameTag:IUCSSTagY] || [self isSameTag:IUCSSTagPercentY]) {
        return YES;
    }
    return NO;
}

@end
