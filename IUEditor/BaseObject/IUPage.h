//
//  IUPage.h
//  IUEditor
//
//  Created by jd on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUObj.h"
#import "IUDocument.h"

@class IUTemplate;

@interface IUPage : IUDocument

-(NSString*)outputSource;
@property (nonatomic) IUTemplate    *aTemplate;

@end