//
//  LMGeneralObject.h
//  IUEditor
//
//  Created by JD on 3/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.


#import <Foundation/Foundation.h>

#define WidgetClassTypePrimary 0
#define WidgetClassTypeSecondary 1
#define WidgetClassTypePG 2


@interface LMGeneralObject : NSObject

@property   NSString    *title;
@property   NSImage     *image;
@property   NSString    *shortDesc;
@property   NSString    *longDesc;
@property   NSMutableDictionary *dict;

@end
