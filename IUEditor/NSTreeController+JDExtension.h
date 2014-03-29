//
//  NSTreeController+JDExtension.h
//  IUEditor
//
//  Created by JD on 3/29/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTreeController (JDExtension)

- (NSIndexPath*)indexPathOfObject:(id)anObject;

- (void)setSelectionObject:(id)object;
- (void)setSelectionObjects:(NSArray*)objects;

@end
