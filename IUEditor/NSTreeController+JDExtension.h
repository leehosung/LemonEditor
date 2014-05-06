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
- (NSArray*)indexPathsOfObject:(id)anObject;

- (void)setSelectedObject:(id)object;
- (void)_setSelectedObjects:(NSArray*)objects;

@end
