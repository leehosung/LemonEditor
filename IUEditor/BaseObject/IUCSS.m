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
    self.editWidth = IUCSSMaxViewPortWidth;
    
    [self updateAssembledTagDictionary];
    return self;
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
        //Border계열일경우, AssembledTagDictionary 전체를 바꾸는 신호를 내보내서 Border Collection정보를 받아옴
        if ([tag isSameTag:IUCSSTagBorderTopWidth] || [tag isSameTag:IUCSSTagBorderLeftWidth] || [tag isSameTag:IUCSSTagBorderRightWidth] || [tag isSameTag:IUCSSTagBorderBottomWidth]
        ) {
            [self willChangeValueForKey:@"assembledTagDictionary"];
        }
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
            if ([tag isSameTag:IUCSSTagBorderTopWidth] || [tag isSameTag:IUCSSTagBorderLeftWidth] || [tag isSameTag:IUCSSTagBorderRightWidth] ) {
                int v = [value intValue];
                cssDict[tag] = @(v);
                [_assembledTagDictionaryForEditWidth setObject:@(v) forKey:tag];
            }
            else {
                cssDict[tag] = value;
                [_assembledTagDictionaryForEditWidth setObject:value forKey:tag];
            }
        }
        
        if ([tag isFrameTag] == NO) {
            if ([tag isHoverTag]) {
                [self.delegate CSSUpdated:tag forWidth:width isHover:YES];
            }
            else {
                [self.delegate CSSUpdated:tag forWidth:width isHover:NO];
            }
        }
        
        if ([tag isSameTag:IUCSSTagBorderTopWidth] || [tag isSameTag:IUCSSTagBorderLeftWidth] || [tag isSameTag:IUCSSTagBorderRightWidth] || [tag isSameTag:IUCSSTagBorderBottomWidth]) {
            [self didChangeValueForKey:@"assembledTagDictionary"];
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
        return;
    }
    else {
        [super setValue:value forKey:keyPath];
        return;
    }
}

-(id)valueForKeyPath:(NSString *)keyPath{
    if ([keyPath containsString:@"assembledTagDictionary."]) {
        NSString *tag = [keyPath substringFromIndex:23];
        if ([tag isSameTag:IUCSSTagBorderWidth]) {
            NSNumber* value = [self.assembledTagDictionary objectForKey:IUCSSTagBorderTopWidth];
            
            if ([value isEqualToNumber:[self.assembledTagDictionary objectForKey:IUCSSTagBorderLeftWidth]] == NO) {
                return NSMultipleValuesMarker;
            }
            
            if ([value isEqualToNumber:[self.assembledTagDictionary objectForKey:IUCSSTagBorderRightWidth]] == NO) {
                return NSMultipleValuesMarker;
            }
            
            if ([value isEqualToNumber:[self.assembledTagDictionary objectForKey:IUCSSTagBorderBottomWidth]] == NO) {
                return NSMultipleValuesMarker;
            }
            
            return value;
        }
        //color multiple
        if ([tag isSameTag:IUCSSTagBorderColor]){
   
            NSColor *topColor = [self.assembledTagDictionary objectForKey:IUCSSTagBorderTopColor];
            NSString *colorString = [topColor rgbaString];
            
            if ([colorString isEqualToString:[[self.assembledTagDictionary objectForKey:IUCSSTagBorderLeftColor] rgbaString]] == NO) {
                return NSMultipleValuesMarker;
            }
            if ([colorString isEqualToString:[[self.assembledTagDictionary objectForKey:IUCSSTagBorderRightColor] rgbaString]] == NO) {
                return NSMultipleValuesMarker;
            }
            if ([colorString isEqualToString:[[self.assembledTagDictionary objectForKey:IUCSSTagBorderBottomColor] rgbaString]] == NO) {
                return NSMultipleValuesMarker;
            }
            return topColor;
        }
        //radius multiple
        if ([tag isSameTag:IUCSSTagBorderRadius]) {
            NSInteger borderTLRadius = [self.assembledTagDictionary[IUCSSTagBorderRadiusTopLeft] integerValue];
            NSInteger borderTRRadius = [self.assembledTagDictionary[IUCSSTagBorderRadiusTopRight] integerValue];
            NSInteger borderBLRadius = [self.assembledTagDictionary[IUCSSTagBorderRadiusBottomLeft] integerValue];
            NSInteger borderBRRadius = [self.assembledTagDictionary[IUCSSTagBorderRadiusBottomRight] integerValue];
            
            if (borderTLRadius == 0 && borderTRRadius == 0 \
                && borderBLRadius == 0 && borderBRRadius == 0) {
                return @(0);
            }
            
            if (borderTLRadius == borderTRRadius && borderTLRadius == borderBLRadius
                && borderTLRadius == borderBRRadius) {
                return @(borderTLRadius);
            }
            return NSMultipleValuesMarker;
        }
        return [_assembledTagDictionaryForEditWidth objectForKey:tag];
    }
    else {
        return [super valueForKey:keyPath];
    }
}


@end