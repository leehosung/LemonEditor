//
//  IUPageContent.m
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPageContent.h"
#import "IUResponsiveSection.h"

@implementation IUPageContent

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.css setValue:[NSColor whiteColor] forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        
        IUResponsiveSection *section = [[IUResponsiveSection alloc] initWithProject:project options:options];
        [section.css setValue:nil forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        [section.css setValue:@(720) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];

        [self addIU:section error:nil];
        
        IUBox *titleBox = [[IUBox alloc] initWithProject:project options:options];
        [titleBox.css setValue:@(240) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@(35) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@(285) forTag:IUCSSTagY forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@(36) forTag:IUCSSTagFontSize forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:[NSColor rgbColorRed:179 green:179 blue:179 alpha:1] forTag:IUCSSTagFontColor forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:nil forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@"Helvetica" forTag:IUCSSTagFontName forWidth:IUCSSMaxViewPortWidth];

        titleBox.positionType = IUPositionTypeAbsoluteCenter;
        titleBox.text = @"Content Area";
        
        [section addIU:titleBox error:nil];
        
        IUBox *contentBox = [[IUBox alloc] initWithProject:project options:options];
        [contentBox.css setValue:@(420) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [contentBox.css setValue:@(75) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [contentBox.css setValue:@(335) forTag:IUCSSTagY forWidth:IUCSSMaxViewPortWidth];
        [contentBox.css setValue:@(18) forTag:IUCSSTagFontSize forWidth:IUCSSMaxViewPortWidth];
        [contentBox.css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign forWidth:IUCSSMaxViewPortWidth];
        [contentBox.css setValue:[NSColor rgbColorRed:179 green:179 blue:179 alpha:1] forTag:IUCSSTagFontColor forWidth:IUCSSMaxViewPortWidth];
        [contentBox.css setValue:nil forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        [contentBox.css setValue:@"Helvetica" forTag:IUCSSTagFontName forWidth:IUCSSMaxViewPortWidth];
        
        contentBox.positionType = IUPositionTypeAbsoluteCenter;
        contentBox.text = @"Double-click to edit text\n\nThis box has absolute-center position.\nFor free movement, see the position at the right.";
        
        [section addIU:contentBox error:nil];
        
        
    }
    return self;
}



#pragma mark - should

-(BOOL)hasX{
    return NO;
}
-(BOOL)hasY{
    return NO;
}
-(BOOL)hasWidth{
    return NO;
}
-(BOOL)hasHeight{
    return NO;
}

-(BOOL)shouldRemoveIU{
    return NO;
}

- (BOOL)canChangePositionType{
    return NO;
}

- (BOOL)canChangeOverflow{
    return NO;
}

- (BOOL)canChangeXByUserInput{
    return NO;
}
- (BOOL)canChangeYByUserInput{
    return NO;
}
- (BOOL)canChangeWidthByUserInput{
    return NO;
}

- (BOOL)canChangeHeightByUserInput{
    return NO;
}
- (BOOL)canCopy{
    return NO;
}


-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width{
    NSMutableDictionary *dict = [[super CSSAttributesForWidth:width ] mutableCopy];
    [dict setObject:@(width) forKey:@"min-width"];
    return dict;
}



@end
