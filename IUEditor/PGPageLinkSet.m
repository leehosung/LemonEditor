//
//  PGPageLinkSet.m
//  IUEditor
//
//  Created by jd on 5/8/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "PGPageLinkSet.h"

@implementation PGPageLinkSet


- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    _pageLinkAlign = IUAlignCenter;
    _selectedButtonBGColor = [NSColor colorWithCalibratedRed:50 green:50 blue:50 alpha:0.5];
    _defaultButtonBGColor = [NSColor colorWithCalibratedRed:50 green:50 blue:50 alpha:0.5];
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
    [self updateCSSForEditViewPort];
}

- (void)setSelectedButtonBGColor:(NSColor *)selectedButtonBGColor{
    _selectedButtonBGColor = selectedButtonBGColor;
    [self updateCSSForMaxViewPort];
}

- (void)setDefaultButtonBGColor:(NSColor *)defaultButtonBGColor{
    _defaultButtonBGColor = defaultButtonBGColor;
    [self updateCSSForMaxViewPort];
}

- (void)setButtonMargin:(float)buttonMargin{
    _buttonMargin = buttonMargin;
    [self updateCSSForMaxViewPort];
}

- (void)updateCSSForEditViewPort{
    [self.delegate IUClassIdentifier:self.cssID CSSUpdated:[self cssForWidth:self.css.editWidth isHover:NO] forWidth:self.css.editWidth];
    [self.delegate IUClassIdentifier:[self.cssID hoverIdentifier] CSSUpdated:[self cssForWidth:self.css.editWidth isHover:YES] forWidth:self.css.editWidth];
}


@end