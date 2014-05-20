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

static NSString * IUEventTagIUID      = @"iuID";
static NSString * IUEventTagVariable  = @"variable";
static NSString * IUEventTagMaxValue  = @"maxValue";
static NSString * IUEventTagInitialValue = @"initialValue";
static NSString * IUEventTagActionType   = @"actionType";

//equation Dict
static NSString * IUEventTagReceiverArray = @"eventReceiverArray";
static NSString * IUEventTagReceiverType = @"receiverType";

static NSString * IUEventTagEnableVisible = @"enableVisible";
static NSString * IUEventTagVisibleID     = @"visibleID";
static NSString * IUEventTagVisibleEqVariable = @"eqVisibleVariable";
static NSString * IUEventTagVisibleEquation = @"eqVisible";
static NSString * IUEventTagVisibleDuration = @"eqVisibleDuration";
static NSString * IUEventTagVisibleDirection = @"directionType";

static NSString * IUEventTagEnableFrame   = @"enableFrame";
static NSString * IUEventTagFrameID       = @"frameID";
static NSString * IUEventTagFrameEqVariable = @"eqFrameVariable";
static NSString * IUEventTagFrameEquation    = @"eqFrame";
static NSString * IUEventTagFrameDuration = @"eqFrameDuration";
static NSString * IUEventTagFrameWidth    = @"eqFrameWidth";
static NSString * IUEventTagFrameHeight   = @"eqFrameHeight";

///////CSSTag
#define IUCSSTag NSString*
static NSString * IUCSSTagPosition = @"position";
static NSString * IUCSSTagFlow = @"flow";

static NSString * IUCSSTagX = @"left";
static NSString * IUCSSTagY = @"top";

static NSString * IUCSSTagWidth = @"width";
static NSString * IUCSSTagHeight = @"height";

static NSString * IUCSSTagXUnit   = @"xUnit";
static NSString * IUCSSTagYUnit   = @"yUnit";
static NSString * IUCSSTagWidthUnit   = @"wUnit";
static NSString * IUCSSTagHeightUnit   = @"hUnit";

static NSString * IUCSSTagPercentX        = @"percentLeft";
static NSString * IUCSSTagPercentY        = @"percentTop";
static NSString * IUCSSTagPercentWidth    = @"percentWidth";
static NSString * IUCSSTagPercentHeight   = @"percentHeight";


//background-image css
static NSString * IUCSSTagImage = @"background-image";
static NSString * IUCSSTagBGSize = @"background-size";
typedef enum{
    IUBGSizeTypeAuto,
    IUBGSizeTypeCover,
    IUBGSizeTypeContain,
    IUBGSizeTypeStretch,
    IUBGSizeTypeCenter,
}IUBGSizeType;

static NSString * IUCSSTagBGXPosition = @"bgX";
static NSString * IUCSSTagBGYPosition = @"bgY";
static NSString * IUCSSTagBGColor = @"background-color";
static NSString * IUCSSTagBGGradient = @"bg-gradient";
static NSString * IUCSSTagBGGradientStartColor = @"bg-gradient-start";
static NSString * IUCSSTagBGGradientEndColor = @"bg-gradient-end";
static NSString * IUCSSTagBGRepeat    = @"bacground-repeat";


static NSString * IUCSSTagBorderWidth = @"borderWeight";
static NSString * IUCSSTagBorderColor = @"borderColor";

static NSString * IUCSSTagBorderTopWidth = @"borderTWeight";
static NSString * IUCSSTagBorderTopColor = @"borderTColor";
static NSString * IUCSSTagBorderRightWidth = @"borderRWeight";
static NSString * IUCSSTagBorderRightColor = @"borderRColor";
static NSString * IUCSSTagBorderLeftWidth = @"borderLWeight";
static NSString * IUCSSTagBorderLeftColor = @"borderLColor";
static NSString * IUCSSTagBorderBottomWidth = @"borderBWeight";
static NSString * IUCSSTagBorderBottomColor = @"borderBColor";

static NSString * IUCSSTagBorderRadius = @"borderRadius";
static NSString * IUCSSTagBorderRadiusTopLeft = @"borderTLRadius";
static NSString * IUCSSTagBorderRadiusTopRight = @"borderTRRadius";
static NSString * IUCSSTagBorderRadiusBottomLeft = @"borderBLRadius";
static NSString * IUCSSTagBorderRadiusBottomRight = @"borderBRRadius";

static NSString * IUCSSTagFontName = @"fontName";
static NSString * IUCSSTagFontSize = @"fontSize";
static NSString * IUCSSTagFontColor = @"fontColor";

static NSString * IUCSSTagFontWeight = @"fontWeight";
static NSString * IUCSSTagFontStyle = @"fontStyle";
static NSString * IUCSSTagTextDecoration = @"textDecoration";

static NSString * IUCSSTagTextAlign = @"textAlign";
typedef enum{
    IUAlignLeft,
    IUAlignCenter,
    IUAlignRight,
    IUAlignJustify,
}IUAlign;

static NSString * IUCSSTagLineHeight = @"lineHeight";

static NSString * IUCSSTagOverflow = @"overflow";

static NSString * IUCSSTagShadowColor = @"shadowColor";
static NSString * IUCSSTagShadowVertical = @"shadowVertical";
static NSString * IUCSSTagShadowHorizontal = @"shadowHorizontal";
static NSString * IUCSSTagShadowSpread = @"shadowSpread";
static NSString * IUCSSTagShadowBlur = @"shadowBlur";

static NSString * IUCSSTagHidden = @"hidden";

//hover CSS
static NSString * IUCSSTagHoverBGImagePositionEnable = @"HoverBGImagePositionEnable";
static NSString * IUCSSTagHoverBGImageX = @"hoverBGImageX";
static NSString * IUCSSTagHoverBGImageY = @"hoverBGImageY";
static NSString * IUCSSTagHoverBGColorEnable  = @"hoverBGColorEnable";
static NSString * IUCSSTagHoverBGColor  = @"hoverBGColor";
static NSString * IUCSSTagHoverTextColorEnable  = @"hoverTextColorEnable";
static NSString * IUCSSTagHoverTextColor  = @"hoverTextColor";

#define isSameTag isEqualToString

@interface NSString (IUTag)
- (NSString*)pixelString;
- (NSString*)percentString;
- (BOOL)isFrameTag;
- (NSString*)hoverIdentifier;
- (BOOL)isHoverTag;

- (NSString*)cssID;
- (NSString*)cssClass;
- (NSString*)cssHoverClass;
- (NSString*)cssActiveClass;
@end
