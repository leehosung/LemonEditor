//
//  IUCarousel.m
//  IUEditor
//
//  Created by jd on 4/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCarousel.h"
#import "IUCarouselItem.h"
#import "IUDocument.h"

@implementation IUCarousel{
    NSInteger   _count;
}

-(id)initWithManager:(IUIdentifierManager *)manager{
    assert(manager!=nil);
    self = [super initWithManager:manager];
    if(self){
        self.count = 3;
        [self.css setValue:@(500) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(300) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        _selectColor = [NSColor blackColor];
        _deselectColor = [NSColor grayColor];
        _rightArrowImage = @"Default";
        _leftArrowImage = @"Default";
    }

    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUCarousel class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUCarousel class] properties]];
    
}



-(BOOL)shouldEditText{
    return NO;
}

-(void)setCount:(NSInteger)count{
    assert(self.identifierManager != nil);
    if (count == 0 || count > 30) {
        return;
    }
    while (_count > count) {
        [self removeIUAtIndex:[self.children count]-1];
        count++;
    }
    BOOL loopFlag = 0;
    while (_count < count) {
        loopFlag = 1;
        IUCarouselItem *item = [[IUCarouselItem alloc] initWithManager:nil];
        item.htmlID = [self.identifierManager requestNewIdentifierWithKey:@"IUCarouselItem"];
        [self.identifierManager addIU:item];
        item.name = @"Item";
        item.carousel = self;
        [self addIU:item error:nil];
        count--;
    }
    [self remakeChildrenHtmlID];
}

-(void)setName:(NSString *)name{
    [super setName:name];
    [self remakeChildrenHtmlID];
}

-(void)remakeChildrenHtmlID{
    for (IUItem *item in self.children) {
        if ([item isKindOfClass:[IUItem class]]) {
            [item setHtmlID:[NSString stringWithFormat:@"%@-Templorary%ld", self.name, [self.children indexOfObject:item]]];
        }
    }
    for (IUItem *item in self.children) {
        if ([item isKindOfClass:[IUItem class]]) {
            [item setHtmlID:[NSString stringWithFormat:@"%@-%ld", self.name, [self.children indexOfObject:item]]];
        }
    }
}

-(NSInteger)count{
    return _count;
}

#pragma mark Inner CSS (Carousel)

- (void)setSelectColor:(NSColor *)selectColor{
    _selectColor = selectColor;
    [self cssForItemColor];
}
- (void)setDeselectColor:(NSColor *)deselectColor{
    _deselectColor = deselectColor;
    [self cssForItemColor];
}

- (void)setEnableColor:(BOOL)enableColor{
    _enableColor = enableColor;
    [self cssForItemColor];
}

- (void)cssForItemColor{
    NSString *itemID = [NSString stringWithFormat:@"%@pager-item", self.htmlID];
    NSString *hoverItemID = [NSString stringWithFormat:@"%@:hover", itemID];
    NSString *activeItemID = [NSString stringWithFormat:@"%@.active", itemID];
    
    if(self.enableColor){
        [self.delegate IU:itemID CSSUpdated:[self.document.compiler cssContentForIUCarouselPager:self hover:NO] forWidth:IUCSSMaxViewPortWidth];
        
        [self.delegate IU:hoverItemID CSSUpdated:[self.document.compiler cssContentForIUCarouselPager:self hover:YES] forWidth:IUCSSMaxViewPortWidth];
        
        [self.delegate IU:activeItemID CSSUpdated:[self.document.compiler cssContentForIUCarouselPager:self hover:YES] forWidth:IUCSSMaxViewPortWidth];
    }
    else{
        [self.delegate IU:itemID CSSRemovedforWidth:IUCSSMaxViewPortWidth];
        [self.delegate IU:hoverItemID CSSRemovedforWidth:IUCSSMaxViewPortWidth];
        [self.delegate IU:activeItemID CSSRemovedforWidth:IUCSSMaxViewPortWidth];
    }
    
}

- (void)setLeftArrowImage:(NSString *)leftArrowImage{
    _leftArrowImage = leftArrowImage;
    BOOL change = NO;
    
    if([leftArrowImage isEqualToString:@"Default"] == NO){
        change = YES;
    }
    [self cssForArrowImage:IUCarouselArrowLeft change:change];
}

- (void)setRightArrowImage:(NSString *)rightArrowImage{
    _rightArrowImage = rightArrowImage;
    BOOL change = NO;
    if([rightArrowImage isEqualToString:@"Default"] == NO){
        change = YES;
    }
    [self cssForArrowImage:IUCarouselArrowRight change:change];

}

- (void)cssForArrowImage:(IUCarouselArrow)type change:(BOOL)change{
    NSString *arrowID;
    if(type == IUCarouselArrowLeft){
        arrowID = [NSString stringWithFormat:@"%@_bx-prev", self.htmlID];
    }
    else if(type == IUCarouselArrowRight){
        arrowID = [NSString stringWithFormat:@"%@_bx-next", self.htmlID];
    }
    if(change){
        [self.delegate IU:arrowID CSSUpdated:[self.document.compiler cssContentForIUCarouselArrow:self hover:NO location:type] forWidth:IUCSSMaxViewPortWidth];
    }else{
        [self.delegate IU:arrowID CSSRemovedforWidth:IUCSSMaxViewPortWidth];
    }
}


#pragma mark JS reload
- (void)setAutoplay:(BOOL)autoplay{
    _autoplay = autoplay;
    [self jsReloadForController];
}
- (void)setDisableArrowControl:(BOOL)disableArrowControl{
    _disableArrowControl = disableArrowControl;
    [self jsReloadForController];
}
- (void)setControlType:(IUCarouselControlType)controlType{
    _controlType = controlType;
    [self jsReloadForController];
}

- (void)jsReloadForController{
    NSString *jsArgs = [self.document.compiler outputJSArgs:self];
    if(jsArgs){
        [self.delegate callWebScriptMethod:@"reloadCarousels" withArguments:@[self.htmlID, jsArgs]];
    }
}
@end