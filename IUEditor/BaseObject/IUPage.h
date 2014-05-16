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

@interface IUPage : IUDocument

@property NSString *title;
@property NSString *keywords;
@property NSString *author;
@property NSString *description;
@property NSString *extraCode;

-(void)setBackground:(IUBackground*)background;
-(IUBackground*)background;

@end