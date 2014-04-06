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

    NSMutableDictionary  *_affectingTagCollectionForEditWidth;
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
    self.editWidth = IUCSSDefaultCollection;
    
    [self updateAffectingTagCollection];
    return self;
}

//insert tag
//use css frame dict, and update affecting tag dictionary
-(void)setValue:(id)value forTag:(IUCSSTag)tag forWidth:(int)width{
    if ([_delegate CSSShouldChangeValue:value forTag:tag forWidth:width]){
        NSMutableDictionary *cssDict = _cssFrameDict[@(width)];
        if (cssDict == nil) {
            cssDict = [NSMutableDictionary dictionary];
            [_cssFrameDict setObject:cssDict forKey:@(width)];
        }
        cssDict[tag] = value;
        //     [self.affectingTagCollection willChangeValueForKey:tag];
        [_affectingTagCollectionForEditWidth setObject:value forKey:tag];
        //     [self.affectingTagCollection didChangeValueForKey:tag];
        [self.delegate CSSChanged:cssDict forWidth:width];
    }
}

-(void)eradicateTag:(IUCSSTag)tag{
    for (id key in _cssFrameDict) {
        NSMutableDictionary *cssDict = _cssFrameDict[key];
        [cssDict removeObjectForKey:tag];
    }
    [self updateAffectingTagCollection];
}


-(NSDictionary*)tagDictionaryForWidth:(int)width{
    return _cssFrameDict[@(width)];
}

-(void)updateAffectingTagCollection{
    [self willChangeValueForKey:@"affectingTagCollection"];
    NSArray *widths = [_cssFrameDict allKeys];
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    NSArray *sortedWidth = [widths sortedArrayUsingDescriptors:@[desc]];
    
    NSMutableDictionary *newCollection = [NSMutableDictionary dictionary];
    for (id key in sortedWidth){
        if ([key intValue] < _editWidth) {
            break;
        }
        [newCollection overwrite: _cssFrameDict[key]];
    }
    _affectingTagCollectionForEditWidth = newCollection;

    [self didChangeValueForKey:@"affectingTagCollection"];
}

-(void)setEditWidth:(int)editWidth{
    _editWidth = editWidth;
    [self updateAffectingTagCollection];
}

-(NSDictionary*)affectingTagCollection{
    return _affectingTagCollectionForEditWidth;
}

-(void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    if ([keyPath containsString:@"affectingTagCollection."]) {
        NSString *tag = [keyPath substringFromIndex:23];
        [self setValue:value forTag:tag forWidth:_editWidth];
    }
    else {
        [super setValue:value forKey:keyPath];
    }
}


@end