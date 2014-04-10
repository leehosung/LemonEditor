//
//  IUPage.h
//  IUEditor
//
//  Created by jd on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBox.h"
#import "IUDocument.h"

@class IUMaster;

@interface IUPage : IUDocument

-(void)setMaster:(IUMaster*)master;
-(IUMaster*)master;

@end