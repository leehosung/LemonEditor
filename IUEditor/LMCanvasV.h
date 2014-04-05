//
//  LMCanvasV.h
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "IUDocument.h"

@interface LMCanvasV : NSView <IUDelegate>

@property (nonatomic) _binding_ IUDocument  *document;
@property (nonatomic) _binding_ NSString    *resourcePath;

@end