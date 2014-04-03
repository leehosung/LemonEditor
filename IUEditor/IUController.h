//
//  IUTreeController.h
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IUController : NSTreeController
@property (readonly) id selection;
- (NSIndexPath*)indexPathOfObject:(id)anObject;

@end
