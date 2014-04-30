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

@property (nonatomic) BOOL autoplay;
@property (nonatomic) BOOL disableArrowControl;
@property (nonatomic) IUCarouselControlType controlType;
@property (nonatomic) NSColor *selectColor;
@property (nonatomic) NSColor *deselectColor;

- (void)setCount:(NSInteger)count;
- (NSInteger)count;

@end