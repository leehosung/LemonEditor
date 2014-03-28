//
//  IUCSS.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUClass.h"

typedef enum _IUCSSType{
    IUCSSTypePosition,
    IUCSSTypeBGColor,
    IUCSSTypeMouseCursor,
}IUCSSType;

@interface IUCSS : NSObject <NSCoding>

-(void)setStyle:(IUCSSType)type value:(id)value;

-(NSDictionary*)tagDictionaryForWidth:(int)width;

-(NSString*)IUCSStypeToString;

@end