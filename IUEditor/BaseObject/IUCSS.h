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
-(void)startGrouping;
-(void)CSSChanged:(IUCSSTag)tag forWidth:(NSInteger)width;
-(BOOL)CSSShouldChangeValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width;
-(void)endGrouping;
@end



@interface IUCSS : NSObject <NSCoding>

@property (nonatomic) _binding_ NSInteger editWidth;
@property (nonatomic) _binding_ NSInteger maxWidth;
@property (strong) id  <IUCSSDelegate> delegate;

//set tag, or delete tag
-(void)setValue:(id)value forTag:(IUCSSTag)tag;
-(void)setValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width;

//remove tag of all tag dictionay in width
-(void)eradicateTag:(IUCSSTag)type;

//get css tag dictionary for specific width
-(NSDictionary*)tagDictionaryForWidth:(NSInteger)width;

//observable.
@property (readonly) NSMutableDictionary *assembledTagDictionary;

@end