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
-(void)CSSUpdatedForWidth:(NSInteger)width isHover:(BOOL)isHover;
-(BOOL)CSSShouldChangeValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width;
@end



@interface IUCSS : NSObject <NSCoding, NSCopying>

@property (nonatomic) _binding_ NSInteger editWidth;
@property (nonatomic) _binding_ NSInteger maxWidth;
@property (weak) id  <IUCSSDelegate> delegate;

//set tag, or delete tag
-(void)setValue:(id)value forTag:(IUCSSTag)tag;
-(void)setValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width;

//remove tag of all tag dictionay in width
-(void)eradicateTag:(IUCSSTag)type;

//get css tag dictionary for specific width
-(NSDictionary*)tagDictionaryForWidth:(NSInteger)width;
-(NSArray*)allEditWidth;

//observable.
@property (readonly) NSMutableDictionary *assembledTagDictionary;
@property (readonly) NSMutableDictionary *tagDictionaryForEditWidth;
@end