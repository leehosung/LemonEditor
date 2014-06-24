//
//  PGTextView.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "PGTextView.h"

@implementation PGTextView

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        _placeholder = @"placeholder";
        _inputValue = @"value example";
        
        [self.css setValue:@(130) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(50) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@"1.3" forTag:IUCSSTagLineHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(IUAlignLeft) forTag:IUCSSTagTextAlign forWidth:IUCSSMaxViewPortWidth];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[PGTextView class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[PGTextView class] properties]];
    
}

- (id)copyWithZone:(NSZone *)zone{
    PGTextView *iu = [super copyWithZone:zone];
    iu.formName = [_formName copy];
    iu.placeholder = [_placeholder copy];
    iu.inputValue = [_inputValue copy];
    return iu;
}

- (BOOL)shouldAddIUByUserInput{
    return NO;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    if(self.delegate){
        [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.htmlID];
    }
}

- (void)setInputValue:(NSString *)inputValue{
    _inputValue = inputValue;
    if(self.delegate){
        [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.htmlID];
    }
}

- (BOOL)hasText{
    return YES;
}

@end
