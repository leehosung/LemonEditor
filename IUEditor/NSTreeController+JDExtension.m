//
//  NSTreeController+JDExtension.m
//  IUEditor
//
//  Created by JD on 3/29/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSTreeController+JDExtension.h"

@implementation NSTreeController (JDExtension)

- (void)setSelectedObject:(id)object{
    [self setSelectedObjects:@[object]];
}

- (void)setSelectedObjects:(NSArray*)objects{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (id anObject in objects) {
        id obj = [self indexPathOfObject:anObject];
        assert(obj);
        [indexPaths addObject:obj];
    }
    [self setSelectionIndexPaths:indexPaths];
}

- (NSIndexPath*)indexPathOfObject:(id)anObject
{
    return [self indexPathOfObject:anObject inNodes:[[self arrangedObjects] childNodes]];
}

- (NSIndexPath*)indexPathOfObject:(id)anObject inNodes:(NSArray*)nodes
{
    for(NSTreeNode* node in nodes)
    {
        if([[node representedObject] isEqual:anObject])
            return [node indexPath];
        if([[node childNodes] count])
        {
            NSIndexPath* path = [self indexPathOfObject:anObject inNodes:[node childNodes]];
            if(path)
                return path;
        }
    }
    return nil;
}

@end
