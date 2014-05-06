//
//  IUFrameDictionary.h
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 31..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IUGuidePixel 5

typedef enum {
    IUFrameLineTop,
    IUFrameLineHorizontalCenter,
    IUFrameLineBottom,
    IUFrameLineLeft,
    IUFrameLineVerticalCenter,
    IUFrameLineRight,
//    IUFrameLineWidth,
//    IUFrameLineHeight,
}IUFrameLine;


@interface PointLine : NSObject

@property NSPoint start;
@property NSPoint end;

@end


@interface IUFrameDictionary : NSObject{
    
}
@property NSMutableDictionary *dict;

- (NSArray *)lineToDrawSamePositionWithIU:(NSString *)IU;
- (BOOL)isGuidePoint:(NSPoint)point;
- (BOOL)isGuideSize:(NSSize)size;
- (NSPoint)guidePointOfCurrentFrame:(NSRect)frame IU:(NSString *)IU;
- (NSSize)guideSizeOfCurrentFrame:(NSRect)frame IU:(NSString *)IU;
- (NSRect)frameOfIU:(NSString *)IU;

@end
