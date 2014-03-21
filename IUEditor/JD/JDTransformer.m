//
//  JDNilToZeroTransformer.m
//  Mango
//
//  Created by JD on 13. 2. 11..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDTransformer.h"

@implementation JDNilToZeroTransformer
+(Class)transformedValueClass {
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}


-(id)transformedValue:(id)value {
    if (value == nil) {
        return [NSNumber numberWithFloat:0];
    }
    else {
        if ([value respondsToSelector: @selector(floatValue)]) {
            float roundFloat = roundf([value floatValue]);
            return [NSNumber numberWithFloat:roundFloat];
        }
        else{
            [NSException raise: NSInternalInconsistencyException format: @"Value (%@) does not respond to -floatValue.", [value class]];
        }
    }
    return nil;
}



@end

@implementation JDNilToHundredTransformer
+(Class)transformedValueClass {
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}


-(id)transformedValue:(id)value {
    if (value == nil) {
        return [NSNumber numberWithInt:1];
    }
    else {
        if ([value respondsToSelector: @selector(floatValue)]) {
            return [NSNumber numberWithFloat:[value floatValue]];
        }
        else{
            [NSException raise: NSInternalInconsistencyException format: @"Value (%@) does not respond to -floatValue.", [value class]];
        }
    }
    return nil;
}

@end


@implementation JDNilToEmptyStringTransformer

+(Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}


-(id)transformedValue:(id)value {
    if (value == nil) {
        return [NSString string];
    }
    return [NSString stringWithString:value];
}


@end
@implementation JDNameTransformer
+(Class)transformedValueClass {
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}


-(id)transformedValue:(id)value {
    if (value == nil) {
        return @"None";
    }
    else {
        return [value valueForKey:@"name"];
    }
    return nil;
}


@end

@implementation IUTextAlignmentTransformer
+(Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}


-(id)transformedValue:(id)value {
    
    if ([value isEqualToString:@"left"]) {
        return @0;
    }
    if ([value isEqualToString:@"center"]) {
        return @1;
    }
    if ([value isEqualToString:@"right"]) {
        return @2;
    }
    return @0;
}

- (id)reverseTransformedValue:(id)value{
    if ([value intValue] == 0) {
        return @"left";
    }
    if ([value intValue] == 1) {
        return @"center";
    }
    if ([value intValue] == 2) {
        return @"right";
    }
    return nil;
}



@end


@implementation JDFirstIndexOfIndexSetTransformer

+(Class)transformedValueClass {
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}


- (id)reverseTransformedValue:(NSMutableIndexSet*)value{
    NSLog(@"reverse transformedValue : %@", [value description]);
    if ([value count] ==0) {
        return @0;
    }
    return [NSNumber numberWithInteger:[value firstIndex]];
}


-(id)transformedValue:(NSNumber*)value {
    NSLog(@"transformedValue : %d", [value intValue]);
    if ( (NSInteger)value == -1) {
        return 0;
    }
    NSIndexSet *idx = [NSIndexSet indexSetWithIndex:[value intValue]];
    return idx;
//    return [NSIndexSet indexSetWithIndex:value];

    /*
    if ([keyPath isEqualToString:@"selectedIndexes"]) {
        if ([self.selectedIndexes count]) {
            NSUInteger selectedIndex = [self.selectedIndexes firstIndex];
            MGImageData *data = [imageDataArray objectAtIndex:selectedIndex];
            [projectWC setSelectedImageData:data];
        }
        return;
    }
*/
}



@end


@implementation JDNSColorToCGColorTransformer

+(Class)transformedValueClass {
    return [NSColor class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}


- (id)reverseTransformedValue:(id)value{
    return [NSColor colorWithCGColor:(CGColorRef)value];

//    return (id)[value CGColor];
}


-(id)transformedValue:(NSColor*)value {
    return (id)[value CGColor];

}


@end



@implementation JDAttrStringToStringTransformer
+ (Class)transformedValueClass
{
    return [NSAttributedString class];
}
+ (BOOL)allowsReverseTransformation
{
    return YES;
}
- (id)transformedValue:(id)value
{
    return (value == nil) ? nil : [[NSAttributedString alloc] initWithString:value];
}

- (id)reverseTransformedValue:(id)value
{
    return (value == nil) ? nil : [[(NSAttributedString *)value string] copy];
}

@end
