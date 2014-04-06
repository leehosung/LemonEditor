//
//  IUCSS.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IUCSSDelegate
@required
-(void)CSSChanged:(NSDictionary*)tagDictionary forWidth:(NSInteger)width;
-(BOOL)CSSShouldChangeValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width;
@end

#define IUCSSDefaultCollection 9999


@interface IUCSS : NSObject <NSCoding>

@property (nonatomic) _binding_ int editWidth;
@property id <IUCSSDelegate> delegate;

//set tag, or delete tag
-(void)setValue:(id)value forTag:(IUCSSTag)tag forWidth:(int)width;

//remove tag of all tag dictionay in width
-(void)eradicateTag:(IUCSSTag)type;

//get css tag dictionary for specific width
-(NSDictionary*)tagDictionaryForWidth:(int)width;

//observable.
@property (readonly) NSDictionary *affectingTagCollection;

@end