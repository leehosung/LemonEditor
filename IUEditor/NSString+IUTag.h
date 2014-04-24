//
//  NSString+IUTag.h
//  IUEditor
//
//  Created by jd on 3/30/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IUCSSTag NSString*
#define IUCSSTagPosition @"position"
#define IUCSSTagFlow @"flow"

#define IUCSSTagX @"left"
#define IUCSSTagY @"top"

#define IUCSSTagWidth @"width"
#define IUCSSTagHeight @"height"

#define IUCSSTagXUnit   @"xUnit"
#define IUCSSTagYUnit   @"yUnit"
#define IUCSSTagWidthUnit   @"wUnit"
#define IUCSSTagHeightUnit   @"hUnit"

#define IUCSSTagPercentX        @"percentLeft"
#define IUCSSTagPercentY        @"percentTop"
#define IUCSSTagPercentWidth    @"percentWidth"
#define IUCSSTagPercentHeight   @"percentHeight"


//background-image css
#define IUCSSTagImage @"background-image"
#define IUCSSTagBGSize @"background-size"
#define IUCSSTagBGXPosition @"bgX"
#define IUCSSTagBGYPosition @"bgY"
#define IUCSSTagBGColor @"background-color"
#define IUCSSTagBGGradient @"bg-gradient"
#define IUCSSTagBGGradientStartColor @"bg-gradient-start"
#define IUCSSTagBGGradientEndColor @"bg-gradient-end"
#define IUCSSTagBGRepeat    @"bacground-repeat"


#define IUCSSTagBorderWidth @"borderWeight"
#define IUCSSTagBorderColor @"borderColor"

#define IUCSSTagBorderTopWidth @"borderTWeight"
#define IUCSSTagBorderTopColor @"borderTColor"
#define IUCSSTagBorderRightWidth @"borderRWeight"
#define IUCSSTagBorderRightColor @"borderRColor"
#define IUCSSTagBorderLeftWidth @"borderLWeight"
#define IUCSSTagBorderLeftColor @"borderLColor"
#define IUCSSTagBorderBottomWidth @"borderBWeight"
#define IUCSSTagBorderBottomColor @"borderBColor"

#define IUCSSTagBorderRadius @"borderRadius"
#define IUCSSTagBorderRadiusTopLeft @"borderTLRadius"
#define IUCSSTagBorderRadiusTopRight @"borderTRRadius"
#define IUCSSTagBorderRadiusBottomLeft @"borderBLRadius"
#define IUCSSTagBorderRadiusBottomRight @"borderBRRadius"



#define IUCSSTagFontName @"font-name"
#define IUCSSTagFontSize @"font-size"

#define IUCSSTagOverflow @"overflow"

#define IUCSSTagShadowColor @"shadowColor"
#define IUCSSTagShadowVertical @"shadowVertical"
#define IUCSSTagShadowHorizontal @"shadowHorizontal"
#define IUCSSTagShadowSpread @"shadowSpread"
#define IUCSSTagShadowBlur @"shadowBlur"

#define IUCSSTagHidden @"hidden"

//hover CSS
#define IUCSSTagHoverBGImagePositionEnable @"HoverBGImagePositionEnable"
#define IUCSSTagHoverBGImageX @"hoverBGImageX"
#define IUCSSTagHoverBGImageY @"hoverBGImageY"
#define IUCSSTagHoverBGColorEnable  @"hoverBGColorEnable"
#define IUCSSTagHoverBGColor  @"hoverBGColor"
#define IUCSSTagHoverTextColorEnable  @"hoverTextColorEnable"
#define IUCSSTagHoverTextColor  @"hoverTextColor"

#define isSameTag isEqualToString

@interface NSString (IUTag)
-(NSString*)pixelString;
-(NSString*)percentString;

@end
