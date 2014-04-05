//
//  IUTreeController.h
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LMCanvasVCDelegate.h"
@class IUDocument;
@interface IUController : NSTreeController <LMCanvasVCDelegate>

//@property IUDocument *content;
//@property (readonly) id selection;
//- (NSIndexPath*)indexPathOfObject:(id)anObject;

//KVC observable

@end
