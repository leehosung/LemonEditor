//
//  IUPage.h
//  IUEditor
//
//  Created by jd on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//


#import "IUBox.h"
#import "IUDocument.h"

@class IUBackground;


/**
  A page class for IU Framework.
 @note IUPage has no children. Do not use 'addIU' function. Program assert failure would be occured immediatly.
       If background is not set, IUPage would never return children.
 */
@interface IUPage : IUDocument

@property NSString *title;
@property NSString *keywords;
@property NSString *author;
@property NSString *desc;
@property NSString *extraCode;

-(void)setBackground:(IUBackground*)background;
-(IUBackground*)background;

@end