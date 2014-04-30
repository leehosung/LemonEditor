//
//  IUCollection.h
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUImport.h"

@interface IUCollection : IUImport
@property NSString *collectionVariable;
@property (nonatomic) BOOL responsiveSupport;
@property (nonatomic) NSArray  *responsiveSetting;
@property (nonatomic) NSInteger defaultItemCount;
@end
