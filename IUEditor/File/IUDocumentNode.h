//
//  IUDocumentNode.h
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUNode.h"


@interface IUDocumentNode : IUNode < NSCoding>
@property (nonatomic)   id document;
@end
