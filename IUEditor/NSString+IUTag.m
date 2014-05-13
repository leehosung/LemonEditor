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

-(NSString*)hoverIdentifier{
    return [self stringByAppendingString:@":hover"];
}

- (BOOL)isHoverTag{
    if ([self isSameTag:IUCSSTagHoverBGImagePositionEnable] || [self isSameTag:IUCSSTagHoverBGImageX] || [self isSameTag:IUCSSTagHoverBGImageY]
        || [self isSameTag:IUCSSTagHoverBGColorEnable]|| [self isSameTag:IUCSSTagHoverBGColor]|| [self isSameTag:IUCSSTagHoverTextColorEnable]
        || [self isSameTag:IUCSSTagHoverTextColor]) {
        return YES;
    }
    return NO;
}

- (NSString*)cssID{
    return [NSString stringWithFormat:@"#%@", self];
}

- (NSString*)cssClass{
    return [NSString stringWithFormat:@".%@", self];
}

- (NSString*)cssHoverClass{
    return [NSString stringWithFormat:@".%@:hover", self];
}

- (NSString*)cssActiveClass{
    return [NSString stringWithFormat:@".%@:active", self];
}

@end
