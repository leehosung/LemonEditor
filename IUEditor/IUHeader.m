//
//  IUHeader.m
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUHeader.h"

@implementation IUHeader

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.css eradicateTag:IUCSSTagWidth];
        [self.css setValue:@(120) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:[NSColor rgbColorRed:50 green:50 blue:50 alpha:1] forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        
        self.positionType = IUPositionTypeRelative;
        
        
        IUBox *titleBox = [[IUBox alloc] initWithProject:project options:options];
        [titleBox.css setValue:@(140) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@(34) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@(43) forTag:IUCSSTagY forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@(24) forTag:IUCSSTagFontSize forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:[NSColor rgbColorRed:153 green:153 blue:153 alpha:1] forTag:IUCSSTagFontColor forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:nil forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        [titleBox.css setValue:@"Helvetica" forTag:IUCSSTagFontName forWidth:IUCSSMaxViewPortWidth];
        
        titleBox.positionType = IUPositionTypeAbsoluteCenter;
        titleBox.text = @"Header Area";
        
        [self addIU:titleBox error:nil];
    }
    return self;
}

-(BOOL)shouldRemoveIU{
    return NO;
}

- (BOOL)canChangePositionType{
    return NO;
}

- (BOOL)hasX{
    return NO;
}

- (BOOL)hasY{
    return NO;
}

- (BOOL)hasWidth{
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

- (BOOL)canCopy{
    return NO;
}
@end
