//
//  NSString+IUTag.h
//  IUEditor
//
//  Created by jd on 3/30/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

////////EventTag
#define IUEventTag NSString*

#define IUEventTagIUID      @"iuID"
#define IUEventTagVariable  @"variable"
#define IUEventTagMaxValue  @"maxValue"
#define IUEventTagInitialValue  @"initialValue"
#define IUEventTagActionType    @"actionType"

//equation Dict
#define IUEventTagReceiverArray @"eventReceiverArray"
#define IUEventTagReceiverType @"receiverType"

#define IUEventTagEnableVisible @"enableVisible"
#define IUEventTagVisibleID     @"visibleID"
#define IUEventTagVisibleEqVariable @"eqVisibleVariable"
#define IUEventTagVisibleEquation @"eqVisible"
#define IUEventTagVisibleDuration @"eqVisibleDuration"
#define IUEventTagVisibleDirection @"directionType"

#define IUEventTagEnableFrame   @"enableFrame"
#define IUEventTagFrameID       @"frameID"
#define IUEventTagFrameEqVariable @"eqFrameVariable"
#define IUEventTagFrameEquation    @"eqFrame"
#define IUEventTagFrameDuration @"eqFrameDuration"
#define IUEventTagFrameWidth    @"eqFrameWidth"
#define IUEventTagFrameHeight   @"eqFrameHeight"

///////CSSTag
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
typedef enum{
    IUBGSizeTypeAuto,
    IUBGSizeTypeCover,
    IUBGSizeTypeContain,
    IUBGSizeTypeStretch,
    IUBGSizeTypeCenter,
}IUBGSizeType;

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

#define IUCSSTagFontName @"fontName"
#define IUCSSTagFontSize @"fontSize"
#define IUCSSTagFontColor @"fontColor"

#define IUCSSTagFontWeight @"fontWeight"
#define IUCSSTagFontStyle @"fontStyle"
#define IUCSSTagTextDecoration @"textDecoration"

#define IUCSSTagTextAlign @"textAlign"
typedef enum{
    IUTextAlignLeft,
    IUTextAlignCenter,
    IUTextAlignRight,
    IUTextAlignJustify,
}IUTextAlign;

#define IUCSSTagLineHeight @"lineHeight"

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
- (NSString*)pixelString;
- (NSString*)percentString;
- (BOOL)isFrameTag;
- (NSString*)hoverIdentifier;
- (BOOL)isHoverTag;
@end
