//
//  IUBackground.h
//  IUEditor
//
//  Created by jd on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUSheet.h"
#import "IUHeader.h"

static NSString* kIUBackgroundOptionEmpty = @"backgroundOptionEmpty";

@interface IUBackground : IUSheet

@property  IUHeader    *header;
@property  (readonly)  NSArray     *bodyParts;

@end