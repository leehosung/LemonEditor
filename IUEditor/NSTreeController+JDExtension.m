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
    [self _setSelectedObjects:@[object]];
}

- (void)_setSelectedObjects:(NSArray*)objects{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (id anObject in objects) {
        id obj = [self indexPathOfObject:anObject];
        NSAssert(obj, @"");
        [indexPaths addObject:obj];
    }
    [self setSelectionIndexPaths:indexPaths];
}

- (NSIndexPath*)indexPathOfObject:(id)anObject
{
    return [self indexPathOfObject:anObject inNodes:[[self arrangedObjects] childNodes]];
}

- (NSArray*)indexPathsOfObject:(id)anObject
{
    return [[self indexPathsOfObject:anObject inNodes:[[self arrangedObjects] childNodes]] copy];
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


- (NSMutableArray*)indexPathsOfObject:(id)anObject inNodes:(NSArray*)nodes
{
    NSMutableArray *retArray = [NSMutableArray array];
    for(NSTreeNode* node in nodes)
    {
        id represented = [node representedObject];
        if([represented isEqual:anObject]){
            [retArray addObject:node.indexPath];
        }
        if([[node childNodes] count])
        {
            [retArray addObjectsFromArray: [self indexPathsOfObject:anObject inNodes:[node childNodes]]];
        }
    }
    return retArray;
}

@end
