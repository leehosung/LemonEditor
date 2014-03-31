//
//  IUPage.h
//  IUEditor
//
//  Created by jd on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUObj.h"
#import "IUDocument.h"

@class IUMaster;

@interface IUPage : IUDocument

@property (nonatomic) IUMaster    *master;

@end