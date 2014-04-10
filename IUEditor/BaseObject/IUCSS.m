//
//  IUCSS.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCSS.h"
#import "IUDefinition.h"
#import "JDUIUtil.h"

@implementation IUCSS{
    NSMutableDictionary  *_cssFrameDict;

    NSMutableDictionary  *_assembledTagDictionaryForEditWidth;
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
    
    [self updateAssembledTagDictionary];
    return self;
}

//insert tag
//use css frame dict, and update affecting tag dictionary
-(void)setValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width{
    
    //check maxWidth
    if(width == self.maxWidth){
        width = IUCSSDefaultCollection;
    }
    
    if ([_delegate CSSShouldChangeValue:value forTag:tag forWidth:width]){
        NSMutableDictionary *cssDict = _cssFrameDict[@(width)];
        if (cssDict == nil) {
            cssDict = [NSMutableDictionary dictionary];
            [_cssFrameDict setObject:cssDict forKey:@(width)];
        }
        if (value == nil) {
            [cssDict removeObjectForKey:tag];
            [_assembledTagDictionaryForEditWidth removeTag:tag];
        }
        else {
            cssDict[tag] = value;
            [_assembledTagDictionaryForEditWidth setObject:value forKey:tag];
        }
        [self.delegate CSSChanged:tag forWidth:width];
    }
}

-(void)eradicateTag:(IUCSSTag)tag{
    for (id key in _cssFrameDict) {
        NSMutableDictionary *cssDict = _cssFrameDict[key];
        [cssDict removeObjectForKey:tag];
    }
    [self updateAssembledTagDictionary];
}


-(NSDictionary*)tagDictionaryForWidth:(NSInteger)width{
    return _cssFrameDict[@(width)];
}

-(void)updateAssembledTagDictionary{
    [self willChangeValueForKey:@"assembledTagDictionary"];
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
    _assembledTagDictionaryForEditWidth = newCollection;

    [self didChangeValueForKey:@"assembledTagDictionary"];
}

-(void)setEditWidth:(NSInteger)editWidth{
    _editWidth = editWidth;
    [self updateAssembledTagDictionary];
}

-(NSDictionary*)assembledTagDictionary{
    return _assembledTagDictionaryForEditWidth;
}

-(void)setValue:(id)value forTag:(IUCSSTag)tag{
    [self setValue:value forTag:tag forWidth:_editWidth];
}

-(void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    if ([keyPath containsString:@"assembledTagDictionary."]) {
        NSString *tag = [keyPath substringFromIndex:23];
        [self setValue:value forTag:tag forWidth:_editWidth];
    }
    else {
        [super setValue:value forKey:keyPath];
    }
}


@end