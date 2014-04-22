//
//  LMPropertyApperenceVC.m
//  IUEditor
//
//  Created by jd on 4/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyBorderVC.h"

@interface LMPropertyBorderVC ()

@property (weak) IBOutlet NSTextField *borderTF;
@property (weak) IBOutlet NSTextField *borderTopTF;
@property (weak) IBOutlet NSTextField *borderRightTF;
@property (weak) IBOutlet NSTextField *borderLeftTF;
@property (weak) IBOutlet NSTextField *borderBottomTF;

@property (weak) IBOutlet NSColorWell *borderColorWell;
@property (weak) IBOutlet NSColorWell *borderTopColorWell;
@property (weak) IBOutlet NSColorWell *borderLeftColorWell;
@property (weak) IBOutlet NSColorWell *borderRightColorWell;
@property (weak) IBOutlet NSColorWell *borderBottomColorWell;

@property (weak) IBOutlet NSTextField *borderRadiusTF;
@property (weak) IBOutlet NSTextField *borderRadiusTopLeftTF;
@property (weak) IBOutlet NSTextField *borderRadiusTopRightTF;
@property (weak) IBOutlet NSTextField *borderRadiusBottomLeftTF;
@property (weak) IBOutlet NSTextField *borderRadiusBottomRightTF;

@end



@implementation LMPropertyBorderVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (NSString*)CSSBindingPath:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}


- (void)setBorderColor:(NSColor *)borderColor{
    _borderColor = borderColor;
    if ([_borderColor isKindOfClass:[NSColor class]]) {
        self.borderTopColor = borderColor;
        self.borderLeftColor = borderColor;
        self.borderRightColor = borderColor;
        self.borderBottomColor = borderColor;
    }
}

- (void)setBorderTopColor:(NSColor *)borderTopColor{
    _borderTopColor = borderTopColor;
    [self setValue:borderTopColor forKeyPath:[self CSSBindingPath:IUCSSTagBorderTopColor]];
}

- (void)setBorderLeftColor:(NSColor *)borderLeftColor{
    _borderLeftColor = borderLeftColor;
    [self setValue:borderLeftColor forKeyPath:[self CSSBindingPath:IUCSSTagBorderLeftColor]];
}

- (void)setBorderRightColor:(NSColor *)borderRightColor{
    _borderRightColor = borderRightColor;
    [self setValue:borderRightColor forKeyPath:[self CSSBindingPath:IUCSSTagBorderRightColor]];
}

- (void)setBorderBottomColor:(NSColor *)borderBottomColor{
    _borderBottomColor = borderBottomColor;
    [self setValue:borderBottomColor forKeyPath:[self CSSBindingPath:IUCSSTagBorderBottomColor]];
}

-(void)awakeFromNib{
    [_borderColorWell bind:@"value" toObject:self withKeyPath:@"borderColor" options:nil];
    [_borderTopColorWell bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderTopColor] options:nil];
    [_borderLeftColorWell bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderLeftColor] options:nil];
    [_borderRightColorWell bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderRightColor] options:nil];
    [_borderBottomColorWell bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderBottomColor] options:nil];
    
    [_borderTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderWidth] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_borderTopTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderTopWidth] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_borderRightTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderRightWidth] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_borderLeftTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderLeftWidth] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_borderBottomTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderBottomWidth] options:@{NSNullPlaceholderBindingOption: @(0)}];

    [_borderRadiusTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderRadius] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_borderRadiusTopLeftTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderRadiusTopLeft] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_borderRadiusTopRightTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderRadiusTopRight] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_borderRadiusBottomLeftTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderRadiusBottomLeft] options:@{NSNullPlaceholderBindingOption: @(0)}];
    [_borderRadiusBottomRightTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBorderRadiusBottomRight] options:@{NSNullPlaceholderBindingOption: @(0)}];
}

-(void)setController:(IUController *)controller{
    _controller = controller;
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderBottomWidth] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderTopWidth] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderLeftWidth] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRightWidth] options:0 context:nil];
    [self addObserver:self forKeyPath:[controller keyPathFromControllerToCSSTag:IUCSSTagBorderTopColor] options:0 context:nil];
    [self addObserver:self forKeyPath:[controller keyPathFromControllerToCSSTag:IUCSSTagBorderLeftColor] options:0 context:nil];
    [self addObserver:self forKeyPath:[controller keyPathFromControllerToCSSTag:IUCSSTagBorderRightColor] options:0 context:nil];
    [self addObserver:self forKeyPath:[controller keyPathFromControllerToCSSTag:IUCSSTagBorderBottomColor] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRadiusTopLeft] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRadiusTopRight] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRadiusBottomLeft] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRadiusBottomRight] options:0 context:nil];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //borderwidth
    if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderTopWidth]) {
        id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderTopWidth]];
        [_borderTopTF setStringValue:value];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderLeftWidth]) {
        id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderLeftWidth]];
        [_borderLeftTF setStringValue:value];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderRightWidth]) {
        id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRightWidth]];
        [_borderRightTF setStringValue:value];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderBottomWidth]) {
        id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderBottomWidth]];
        [_borderBottomTF setStringValue:value];
    }
    id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderWidth]];
    [_borderTF setStringValue:value];
    //bordercolor
    if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderTopColor]) {
        NSColor *newColor = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderTopColor]];
        if (self.borderTopColor != newColor) {
            self.borderTopColor = newColor;
        }
    }
    NSString *keyPath2 =[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderColor];
    
    NSColor *borderColor = [self valueForKeyPath:keyPath2];
    if (self.borderColor != borderColor) {
        self.borderColor = borderColor;
    }
    //border radius
    if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderRadiusTopLeft]) {
        id value = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusTopLeft]];
        if (value) {
            [_borderRadiusTopLeftTF setStringValue:value];
        }
        else {
            [_borderRadiusTopLeftTF setStringValue:@"0"];
        }
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderRadiusTopRight]) {
        id value = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusTopRight]];
        if (value) {
            [_borderRadiusTopRightTF setStringValue:value];
        }
        else {
            [_borderRadiusTopRightTF setStringValue:@"0"];
        }
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderRadiusBottomLeft]) {
        id value = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusBottomLeft]];
        if (value) {
            [_borderRadiusBottomLeftTF setStringValue:value];
        }
        else {
            [_borderRadiusBottomLeftTF setStringValue:@"0"];
        }
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderRadiusBottomRight]) {
        id value = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBorderRadiusBottomRight]];
        if (value) {
            [_borderRadiusBottomRightTF setStringValue:value];
        }
        else {
            [_borderRadiusBottomRightTF setStringValue:@"0"];
        }
    }
    id value2 = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRadius]];
    [_borderRadiusTF setStringValue:value2];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj{
    NSTextField *changedField = [obj object];
    
    if (changedField == _borderTF) {
        id value = @(_borderTF.integerValue);
        for (IUBox *box in _controller.selectedObjects) {
            [box startGrouping];
        }
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderTopWidth]];
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderLeftWidth]];
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRightWidth]];
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderBottomWidth]];
        for (IUBox *box in _controller.selectedObjects) {
            [box endGrouping];
        }
    }
    else if (changedField == _borderTopTF) {
        [_controller.selection setValue:@(_borderTopTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderTopWidth]];
    }
    else if (changedField == _borderLeftTF) {
        [_controller.selection setValue:@(_borderLeftTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderLeftWidth]];
    }
    else if (changedField == _borderRightTF) {
        [_controller.selection setValue:@(_borderRightTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRightWidth]];
    }
    else if (changedField == _borderBottomTF) {
        [_controller.selection setValue:@(_borderBottomTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderBottomWidth]];
    }
    
    if (changedField == _borderRadiusTF) {
        id value = @(_borderRadiusTF.integerValue);
        for (IUBox *box in _controller.selectedObjects){
            [box startGrouping];
        }
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary"stringByAppendingPathExtension:IUCSSTagBorderRadiusTopLeft]];
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary"stringByAppendingPathExtension:IUCSSTagBorderRadiusTopRight]];
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary"stringByAppendingPathExtension:IUCSSTagBorderRadiusBottomLeft]];
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary"stringByAppendingPathExtension:IUCSSTagBorderRadiusBottomRight]];
        for (IUBox *box in _controller.selectedObjects) {
            [box endGrouping];
        }
    }
    else if (changedField == _borderRadiusTopLeftTF){
        [_controller.selection setValue:@(_borderRadiusTopLeftTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRadiusTopLeft]];
    }
    else if (changedField == _borderRadiusTopRightTF) {
        [_controller.selection setValue:@(_borderRadiusTopRightTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRadiusTopRight]];
    }
    else if (changedField == _borderRadiusBottomLeftTF) {
        [_controller.selection setValue:@(_borderRadiusBottomLeftTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRadiusBottomLeft]];
    }
    else if (changedField == _borderRadiusBottomRightTF) {
        [_controller.selection setValue:@(_borderRadiusBottomRightTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRadiusBottomRight]];
    }
}

@end