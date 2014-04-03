//
//  IUCSS.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>



#define IUCSSDefaultCollection 9999


@interface IUCSS : NSObject <NSCoding>

@property (nonatomic) _binding_ int editWidth;

-(void)setValue:(id)value forTag:(IUCSSTag)tag forWidth:(int)width;

-(void)eradicateTag:(IUCSSTag)type;


-(NSDictionary*)tagDictionaryForWidth:(int)width;

@property (readonly) NSDictionary *cssCollectionForEditWidth;
-(void)setValue:(id)value forKeyPath:(NSString *)keyPath;

@end