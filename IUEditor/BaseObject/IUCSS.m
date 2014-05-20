//
//  IUCSS.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCSS.h"
#import "JDUIUtil.h"

@interface IUCSS ()
@property NSMutableDictionary *cssFrameDict;
@property (readwrite) NSMutableDictionary *assembledTagDictionaryForEditWidth;
@property (readwrite) NSMutableDictionary *tagDictionaryForEditWidth;
@end

@implementation IUCSS{
}


-(NSArray*)allEditWidth{
    return [self.cssFrameDict allKeys];
}

-(id)init{
    self = [super init];
    _cssFrameDict = [[NSMutableDictionary alloc] init];
    self.editWidth = IUCSSMaxViewPortWidth;
    
    [self updateAssembledTagDictionary];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_cssFrameDict forKey:@"cssFrameDict"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    _cssFrameDict = [aDecoder decodeObjectForKey:@"cssFrameDict"];
    self.editWidth = IUCSSMaxViewPortWidth;
    
    [self updateAssembledTagDictionary];
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IUCSS *css = [[[self class] allocWithZone:zone] init];
    css.cssFrameDict = [self.cssFrameDict deepCopy];
    css.assembledTagDictionaryForEditWidth = [self.assembledTagDictionaryForEditWidth deepCopy];
    return css;
}



- (BOOL)isPercentTag:(IUCSSTag)tag{
    if([tag isEqualToString:IUCSSTagPercentX]){
        return YES;
    }
    else if([tag isEqualToString:IUCSSTagPercentY]){
        return YES;
    }
    else if([tag isEqualToString:IUCSSTagPercentWidth]){
        return YES;
    }
    else if([tag isEqualToString:IUCSSTagPercentHeight]){
        return YES;
    }
    return NO;
}

//insert tag
//use css frame dict, and update affecting tag dictionary
-(void)setValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width{
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
        
        if ([tag isFrameTag] == NO) {
            if ([tag isHoverTag]) {
                [self.delegate CSSUpdated:tag forWidth:width isHover:YES];
            }
            else {
                [self.delegate CSSUpdated:tag forWidth:width isHover:NO];
            }
        }
        
    }
}


-(void)eradicateTag:(IUCSSTag)tag{
    for (id key in _cssFrameDict) {
        NSMutableDictionary *cssDict = _cssFrameDict[key];
        [cssDict removeObjectForKey:tag];
    }
    [self updateAssembledTagDictionary];
    [self.delegate CSSUpdated:tag forWidth:IUCSSMaxViewPortWidth isHover:NO];
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

-(NSMutableDictionary*)tagDictionaryForEditWidth{
    return _cssFrameDict[@(_editWidth)];
}

-(NSMutableDictionary*)assembledTagDictionary{
    return _assembledTagDictionaryForEditWidth;
}

-(void)setValue:(id)value forTag:(IUCSSTag)tag{
    [self setValue:value forTag:tag forWidth:_editWidth];
}

-(void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    if ([keyPath containsString:@"assembledTagDictionary."]) {
        NSString *tag = [keyPath substringFromIndex:23];
        [self setValue:value forTag:tag forWidth:_editWidth];
        return;
    }
    else {
        [super setValue:value forKey:keyPath];
        return;
    }
}

- (BOOL)isSameBorder{
    int borderTop = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderTopWidth] intValue];
    int borderBottom = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderBottomWidth] intValue];
    int borderLeft = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderLeftWidth] intValue];
    int borderRight = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRightWidth] intValue];
    
    if(borderTop == borderBottom == borderLeft == borderRight){
        return YES;
    }
    return NO;
}
- (BOOL)isSameRadius{
    int borderTLRadius = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRadiusTopLeft] intValue];
    int borderTRRadius = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRadiusTopRight] intValue];
    int borderBLRadius = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRadiusBottomLeft] intValue];
    int borderBRRadius = [[self.assembledTagDictionary objectForKey:IUCSSTagBorderRadiusBottomRight] intValue];
    
    if(borderTLRadius == borderTRRadius == borderBLRadius == borderBRRadius){
        return YES;
    }
    return NO;
}

-(id)valueForKeyPath:(NSString *)keyPath{
    if ([keyPath containsString:@"assembledTagDictionary."]) {
        NSString *tag = [keyPath substringFromIndex:23];
        if ([tag isSameTag:IUCSSTagBorderWidth]) {
            NSNumber* value = [self.assembledTagDictionary objectForKey:IUCSSTagBorderWidth];
            if(value == nil){
                return @(0);
            }
            if([self isSameBorder]){
                return value;
            }
            else{
                return NSMultipleValuesMarker;
            }
        }
        //radius multiple
        if ([tag isSameTag:IUCSSTagBorderRadius]) {
            NSNumber* value = [self.assembledTagDictionary objectForKey:IUCSSTagBorderRadius];
            if(value == nil){
                return @(0);
            }
            if([self isSameRadius]){
                return value;
            }
            else{
                return NSMultipleValuesMarker;
            }
        }
        return [_assembledTagDictionaryForEditWidth objectForKey:tag];
    }
    else {
        return [super valueForKey:keyPath];
    }
}


@end