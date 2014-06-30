//
//  PGTextField.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "PGTextField.h"

@implementation PGTextField


-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        _placeholder = @"placeholder";
        _inputValue = @"value example";
        _type = IUTextFieldTypeDefault;
        
        [self.css setValue:@(130) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(30) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[PGTextField class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[PGTextField class] properties]];
    
}

- (id)copyWithZone:(NSZone *)zone{
    PGTextField *iu = [super copyWithZone:zone];
    iu.inputName = [_inputName copy];
    iu.placeholder = [_placeholder copy];
    iu.inputValue = [_inputValue copy];
    iu.type = _type;
    return iu;
}


#pragma mark -
#pragma mark should

- (BOOL)shouldAddIUByUserInput{
    return NO;
}

#pragma mark -
#pragma mark setting
- (BOOL)hasText{
    return YES;
}

- (void)setInputName:(NSString *)inputName{
    _inputName = inputName;
    [self updateHTML];
    [self updateJS];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    [self updateHTML];
    [self updateJS];
}

- (void)setInputValue:(NSString *)inputValue{
    _inputValue = inputValue;
    [self updateHTML];
    [self updateJS];
}
- (void)setType:(IUTextFieldType)type{
    _type = type;
    [self updateHTML];
    [self updateJS];
}

@end
