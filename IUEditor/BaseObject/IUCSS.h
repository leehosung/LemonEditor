//
//  IUCSS.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>



#define IUCSSTagDictionaryDefaultWidth -1

@interface IUCSS : NSObject <NSCoding>

-(void)setStyle:(IUCSSTag)type value:(id)value;
-(void)removeStyle:(IUCSSTag)type;

-(NSDictionary*)tagDictionaryForWidth:(int)width;


@end