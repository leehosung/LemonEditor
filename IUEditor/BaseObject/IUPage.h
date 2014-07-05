//
//  IUPage.h
//  IUEditor
//
//  Created by jd on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//


#import "IUBox.h"
#import "IUSheet.h"

@class IUBackground;
@class IUPageContent;

/**
  A page class for IU Framework.
 @note IUPage has no children. Do not use 'addIU' function. Program NSAssert failure would be occured immediatly.
       If background is not set, IUPage would never return children.
 */
@interface IUPage : IUSheet

@property NSString *title;
@property NSString *keywords;
@property NSString *author;
@property NSString *desc;
@property NSString *extraCode;

-(void)setBackground:(IUBackground*)background;
-(IUBackground*)background;
-(IUPageContent *)pageContent;

@end