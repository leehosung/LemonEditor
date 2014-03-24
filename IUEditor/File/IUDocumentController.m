//
//  IUDocumentController.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocumentController.h"

@implementation IUDocumentController
-(id)initWithDocument:(IUDocument*)document{
    self = [super init];
    if (self) {
        [self setContent:document];
    }
    return self;
}

@end
