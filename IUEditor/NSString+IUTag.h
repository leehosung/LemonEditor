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
#define IUCSSTagBGColor @"background-color"
#define IUCSSTagX @"left"
#define IUCSSTagY @"top"
#define IUCSSTagWidth @"width"
#define IUCSSTagHeight @"height"
#define IUCSSTagImage @"background-image"
#define IUCSSTagBGSize @"background-size"
#define IUCSSTagBGXPosition @"bgX"
#define IUCSSTagBGYPosition @"bgY"

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


#define IUCSSTagFontName @"font-name"
#define IUCSSTagFontSize @"font-size"


#define isSameTag isEqualToString

@interface NSString (IUTag)
-(NSString*)pixelString;
-(NSString*)percentString;

@end
