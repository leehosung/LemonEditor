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
    IUCarouselControlTypeNone,
    
}IUCarouselControlType;

typedef enum{
    IUCarouselArrowLeft,
    IUCarouselArrowRight,
}IUCarouselArrow;

@interface IUCarousel : IUBox

@property (nonatomic) BOOL autoplay, enableColor;
@property (nonatomic) BOOL disableArrowControl;
@property (nonatomic) IUCarouselControlType controlType;
@property (nonatomic) NSColor *selectColor;
@property (nonatomic) NSColor *deselectColor;
@property (nonatomic) NSString *leftArrowImage, *rightArrowImage;
@property (nonatomic) NSInteger count;

- (NSString *)carouselAttributes;

@end