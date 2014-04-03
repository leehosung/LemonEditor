//
//  IUCSS.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCSS.h"
#import "JDUIUtil.h"


@implementation IUCSS{
    NSMutableDictionary  *_cssFrameDict;
    NSArray       *_cssFrameSortedArray;

    NSDictionary  *_cssCollectionForEditWidth;
}

-(id)init{
    self = [super init];
    _cssFrameDict = [[NSMutableDictionary alloc] init];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_cssFrameDict forKey:@"cssFrameDict"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    _cssFrameDict = [aDecoder decodeObjectForKey:@"cssFrameDict"];
    return self;
}

-(void)setValue:(id)value forTag:(IUCSSTag)tag forWidth:(int)width{
    NSMutableDictionary *cssDict = _cssFrameDict[@(width)];
    if (cssDict == nil) {
        cssDict = [NSMutableDictionary dictionary];
        [_cssFrameDict setObject:cssDict forKey:@(width)];
    }
    cssDict[tag] = value;
}

-(void)eradicateTag:(IUCSSTag)tag{
    for (id key in _cssFrameDict) {
        NSMutableDictionary *cssDict = _cssFrameDict[key];
        [cssDict removeObjectForKey:tag];
    }
}



-(NSDictionary*)tagDictionaryForWidth:(int)width{
    return _cssFrameDict[@(width)];
}

-(void)setEditWidth:(int)editWidth{
    _editWidth = editWidth;
    [self willChangeValueForKey:@"cssCollection"];

    
    NSArray *widths = [_cssFrameDict allKeys];
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    NSArray *sortedWidth = [widths sortedArrayUsingDescriptors:@[desc]];

    NSMutableDictionary *newCollection = [NSMutableDictionary dictionary];
    for (id key in sortedWidth){
        if ([key intValue] < editWidth) {
            break;
        }
        [newCollection overwrite: _cssFrameDict[key]];
    }
    _cssCollectionForEditWidth = [newCollection copy];
    
    [self didChangeValueForKey:@"cssCollection"];
}

-(NSDictionary*)cssCollectionForEditWidth{
    return _cssCollectionForEditWidth;
}

@end