//
//  IUPageLinkSet.m
//  IUEditor
//
//  Created by jd on 5/8/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPageLinkSet.h"

@implementation IUPageLinkSet


- (id)initWithManager:(IUIdentifierManager *)identifierManager option:(NSDictionary *)option{
    self = [super initWithManager:identifierManager option:option];
    _pageLinkAlign = IUAlignCenter;
    _selectedButtonBGColor = [NSColor blueColor];
    _defaultButtonBGColor = [NSColor yellowColor];
    _buttonMargin = 5.0f;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[self class] properties]];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[[self class] properties]];
    _buttonMargin = 2;
    return self;
}

- (void)setPageLinkAlign:(IUAlign)pageLinkAlign{
    _pageLinkAlign = pageLinkAlign;
    [self.delegate IUClassIdentifier:self.htmlID CSSUpdated:[self cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
}

- (void)setSelectedButtonBGColor:(NSColor *)selectedButtonBGColor{
    _selectedButtonBGColor = selectedButtonBGColor;
    [self.delegate IUClassIdentifier:self.htmlID CSSUpdated:[self cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
}

- (void)setDefaultButtonBGColor:(NSColor *)defaultButtonBGColor{
    _defaultButtonBGColor = defaultButtonBGColor;
    [self.delegate IUClassIdentifier:self.htmlID CSSUpdated:[self cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
}

- (void)setButtonMargin:(float)buttonMargin{
    _buttonMargin = buttonMargin;
    [self.delegate IUClassIdentifier:self.htmlID CSSUpdated:[self cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
}

@end