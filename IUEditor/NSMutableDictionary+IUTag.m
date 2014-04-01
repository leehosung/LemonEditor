  //
//  NSMutableDictionary+IUTag.m
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSMutableDictionary+IUTag.h"
#import "JDUIUtil.h"

@implementation NSMutableDictionary (IUTag)

-(void)putTag:(NSString*)tag intValue:(int)intValue ignoreZero:(BOOL)ignoreZero unit:(IUCSSUnit)unit{
    if (ignoreZero && intValue == 0) {
        return;
    }
    switch (unit) {
        case IUCSSUnitNone:
            self[tag] = [NSString stringWithFormat:@"%d", intValue];
            break;
        case IUCSSUnitPercent:
            self[tag] = [NSString stringWithFormat:@"%d%%", intValue];
            break;
        case IUCSSUnitPixel:
            self[tag] = [NSString stringWithFormat:@"%dpx", intValue];
            break;
        default:
            assert(0);
            break;
    }
}

-(void)putTag:(NSString*)tag floatValue:(float)floatValue ignoreZero:(BOOL)ignoreZero unit:(IUCSSUnit)unit{
    if (ignoreZero && floatValue == 0) {
        return;
    }
    switch (unit) {
        case IUCSSUnitNone:
            self[tag] = [[NSString stringWithFormat:@"%.4f", floatValue] stringByReplacingOccurrencesOfString:@".0000" withString:@""];
            break;
        case IUCSSUnitPercent:
            self[tag] = [[NSString stringWithFormat:@"%.4f%%", floatValue] stringByReplacingOccurrencesOfString:@".0000" withString:@""];
            break;
        case IUCSSUnitPixel:
            self[tag] = [[NSString stringWithFormat:@"%.4fpx", floatValue] stringByReplacingOccurrencesOfString:@".0000" withString:@""];
            break;
        default:
            assert(0);
            break;
    }
}

-(void)putTag:(NSString*)tag color:(NSColor*)color{
    if (color) {
        self[tag] = [color rgbString];
    }
}

-(void)putTag:(NSString*)tag string:(NSString*)stringValue{
    if ([stringValue length]) {
        self[tag] = stringValue;
    }
}

-(void)removeTag:(NSString*)tag{
    [self removeObjectForKey:tag];
}

@end
