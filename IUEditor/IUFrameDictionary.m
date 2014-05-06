//
//  IUFrameDictionary.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 31..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "IUFrameDictionary.h"

@implementation PointLine

+(PointLine *)makePointLine:(NSPoint)startPoint endPoint:(NSPoint)endPoint{
    
    PointLine *line = [[PointLine alloc] init];
    line.start = NSMakePoint(round(startPoint.x), round(startPoint.y));
    line.end = NSMakePoint(round(endPoint.x), round(endPoint.y));
    return line;
}


@end

@implementation IUFrameDictionary

- (id)init{
    self = [super init];
    if(self){
        self.dict = [NSMutableDictionary dictionary];
    }
    return self;
}


- (NSArray *)lineToDrawSamePositionWithIU:(NSString *)IU{
    NSMutableArray *drawArray = [NSMutableArray array];
    
    //1. find v center of page
    //2. find h center of page
    
    
    //3. top line, 4. hc line, 5. bottom line
    for(int i=IUFrameLineTop; i<=IUFrameLineBottom; i++ ){
        PointLine *line =[self sameHorizontalLine:IU type:(IUFrameLine)i];
        if(line){
            [drawArray addObject:line];
        }
    }
    
    //6. left line, 7. v center line, 8. right line
    for(int i=IUFrameLineLeft; i<=IUFrameLineRight; i++ ){
        PointLine *line =[self sameVerticalLine:IU type:(IUFrameLine)i];
        if(line){
            [drawArray addObject:line];
        }
    }
    
    return drawArray;
}

#pragma mark -
#pragma mark common methods

- (BOOL)isSameFloat:(CGFloat)a b:(CGFloat)b{
    if(abs(a-b) < 1){//1 pixel 이하면 같은 라인에 있는걸로.
        return YES;
    }
    return NO;
}

- (BOOL)isInGuideLine:(CGFloat)a b:(CGFloat)b{
    if(abs(a-b) <=IUGuidePixel){
        return YES;
    }
    return NO;
}

- (NSArray *)allKeysExceptKey:(NSString *)key{
    
    NSMutableArray *allKeys =  [NSMutableArray arrayWithArray:[self.dict allKeys]];
    [allKeys removeObject:key];

    return allKeys;
}



- (CGFloat)floatValue:(NSRect)frame withType:(IUFrameLine)type{
    CGFloat value;
    switch (type) {
        case IUFrameLineTop:
            value = NSMinY(frame);
            break;
        case IUFrameLineHorizontalCenter:
            value = NSMidY(frame);
            break;
        case IUFrameLineBottom:
            value = NSMaxY(frame);
            break;
        case IUFrameLineLeft:
            value = NSMinX(frame);
            break;
        case IUFrameLineVerticalCenter:
            value = NSMidX(frame);
            break;
        case IUFrameLineRight:
            value = NSMaxX(frame);
            break;
        default:
            JDWarnLog( @"there is no type");
            break;
    }
    return value;
}

#pragma mark -
#pragma mark check within 5pixel
- (BOOL)isGuidePoint:(NSPoint)point{
    return NO;
    if(point.x > IUGuidePixel || point.y > IUGuidePixel){
        return NO;
    }
    
    return YES;
}

- (BOOL)isGuideSize:(NSSize)size{
    return NO;
    if(size.width > IUGuidePixel || size.height > IUGuidePixel){
        return NO;
    }
    return YES;
}

- (NSPoint)guidePointOfCurrentFrame:(NSRect)frame IU:(NSString *)IU{
    
    NSPoint point = NSMakePoint(frame.origin.x, frame.origin.y);
    
    for(int i=IUFrameLineTop; i<=IUFrameLineBottom; i++ ){
        NSRect guideFrame = [self findHorizontalGuideLine:IU type:(IUFrameLine)i];
        if( NSIsEmptyRect(guideFrame) ){
            point.y = guideFrame.origin.y;
        }
    }
    
    for(int i=IUFrameLineLeft; i<=IUFrameLineRight; i++ ){
        NSRect guideFrame = [self findVerticalGuideLine:IU type:(IUFrameLine)i];
        if( NSIsEmptyRect(guideFrame) ){
            point.x = guideFrame.origin.x;
        }
    }
    return point;
}


- (NSSize)guideSizeOfCurrentFrame:(NSRect)frame IU:(NSString *)IU{
    NSArray *allKeys = [self allKeysExceptKey:IU];
    NSSize guideSize = frame.size;

    
    for(NSString *compareKey in allKeys){
        
        NSRect compareFrame = [[self.dict objectForKey:compareKey] rectValue];
        
        if( [self isInGuideLine:NSMaxX(frame) b:NSMaxX(compareFrame)]) {
            guideSize.width = NSMaxX(compareFrame) - NSMinX(frame);
        }
        
        if( [self isInGuideLine:NSMaxY(frame) b:NSMaxY(compareFrame)]){
            guideSize.height = NSMaxY(compareFrame) - NSMinY(frame);
        }
        
    }
    
    return guideSize;
}


#pragma mark -
#pragma mark find guide location

- (NSRect)findHorizontalGuideLine:(NSString *)key type:(IUFrameLine)type {
    NSArray *allKeys = [self allKeysExceptKey:key];
    NSRect keyRect = [[self.dict objectForKey:key] rectValue];
    CGFloat typeY = [self floatValue:keyRect withType:type];
    
    for(NSString *compareKey in allKeys){
        
        NSRect frame = [[self.dict objectForKey:compareKey] rectValue];
        CGFloat compareY = [self floatValue:frame withType:type];
        
        if( [self isInGuideLine:typeY b:compareY]) {
            return frame;
        }
        
    }

    return NSZeroRect;
}

- (NSRect)findVerticalGuideLine:(NSString *)key type:(IUFrameLine)type {
    NSArray *allKeys = [self allKeysExceptKey:key];
    NSRect keyRect = [[self.dict objectForKey:key] rectValue];
    CGFloat typeX = [self floatValue:keyRect withType:type];
    
    
    for(NSString *compareKey in allKeys){
        
        NSRect frame = [[self.dict objectForKey:compareKey] rectValue];
        CGFloat compareX = [self floatValue:frame withType:type];
        
        if( [self isInGuideLine:typeX b:compareX]) {
            return frame;
        }
        
    }
    return NSZeroRect;
}

#pragma mark -
#pragma mark find same location

- (PointLine *)sameHorizontalLine:(NSString *)key type:(IUFrameLine)type {
    NSArray *allKeys = [self allKeysExceptKey:key];
    NSRect keyRect = [[self.dict objectForKey:key] rectValue];
    CGFloat minX = NSMinX(keyRect);
    CGFloat maxX = NSMaxX(keyRect);
    CGFloat typeY = [self floatValue:keyRect withType:type];
    BOOL isFind = NO;
    
    for(NSString *compareKey in allKeys){
        
        NSRect frame = [[self.dict objectForKey:compareKey] rectValue];
        CGFloat compareY = [self floatValue:frame withType:type];
        
        if( [self isSameFloat:typeY b:compareY]) {
            isFind = YES;
            
            if(minX > NSMinX(frame)){
                minX = NSMinX(frame);
            }
            if(maxX < NSMaxX(frame)){
                maxX = NSMaxX(frame);
            }

        }
        
    }
    
    if(isFind){
        NSPoint startPoint = NSMakePoint(minX, typeY);
        NSPoint endPoint = NSMakePoint(maxX, typeY);
        return [PointLine makePointLine:startPoint endPoint:endPoint];
        
    }
    else {
        return nil;
    }
}

- (PointLine *)sameVerticalLine:(NSString *)key type:(IUFrameLine)type {
    NSArray *allKeys = [self allKeysExceptKey:key];
    NSRect keyRect = [[self.dict objectForKey:key] rectValue];
    CGFloat minY = NSMinY(keyRect);
    CGFloat maxY = NSMaxY(keyRect);
    CGFloat typeX = [self floatValue:keyRect withType:type];
    BOOL isFind = NO;

    
    for(NSString *compareKey in allKeys){
        
        NSRect frame = [[self.dict objectForKey:compareKey] rectValue];
        CGFloat compareX = [self floatValue:frame withType:type];
        
        if( [self isSameFloat:typeX b:compareX]) {
            isFind = YES;
            if(minY > NSMinY(frame)){
                minY = NSMinY(frame);
            }
            if(maxY < NSMaxY(frame)){
                maxY = NSMaxY(frame);
            }
        }
        
    }
    
    if(isFind){
        NSPoint startPoint = NSMakePoint(typeX, minY);
        NSPoint endPoint = NSMakePoint(typeX, maxY);
        return [PointLine makePointLine:startPoint endPoint:endPoint];
        
    }
    else {
        return nil;
    }
}

- (NSRect)frameOfIU:(NSString *)IU{
    return [[_dict objectForKey:IU] rectValue];
}

#pragma mark find same size
#if 0
- (NSArray *)sameSize:(NSString *)key type:(IUFrameLine)type{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *allKeys = [self allKeysExceptKey:key];
    NSRect keyRect = [[self.dict objectForKey:key] rectValue];
    CGFloat value = [self floatValue:keyRect withType:type];
    
    for(NSString *compareKey in allKeys){
        
        NSRect frame = [[self.dict objectForKey:compareKey] rectValue];
        CGFloat compareValue = [self floatValue:frame withType:type];
        
        if( [self isSameFloat:value b:compareValue]) {
            NSPoint startPoint = NSMakePoint(frame.origin.x, frame.origin.y);
            NSPoint endPoint;
            if(type == IUFrameLineWidth){
                endPoint = NSMakePoint(frame.origin.x+frame.size.width, frame.origin.y);
            }
            
            else if(type == IUFrameLineHeight){
                endPoint = NSMakePoint(frame.origin.x, frame.origin.y+frame.size.height);
            }
            
            PointLine *line = [PointLine makePointLine:startPoint endPoint:endPoint];
            [array addObject:line];

        }
        
    }
    return array;
}
#endif



@end
