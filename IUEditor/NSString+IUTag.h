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


#define isSameTag isEqualToString

@interface NSString (IUTag)
-(NSString*)pixelString;
-(NSString*)percentString;

@end
