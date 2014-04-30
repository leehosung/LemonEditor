//
//  IUCarousel.h
//  IUEditor
//
//  Created by jd on 4/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBox.h"

typedef enum{
    IUCarouselControlBottom,
    IUCarouselControlBottomNPlay,
    IUCarouselControlTypeNone,
    
}IUCarouselControlType;

@interface IUCarousel : IUBox

@property BOOL autoplay;
@property BOOL enableArrowControl;
@property IUCarouselControlType controlType;
@property NSColor *selectColor;
@property NSColor *deselectColor;

- (void)setCount:(NSInteger)count;
- (NSInteger)count;

@end