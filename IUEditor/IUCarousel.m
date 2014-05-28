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

-(id)initWithIdentifierManager:(IUIdentifierManager *)manager option:(NSDictionary *)option{
    assert(manager!=nil);
    self = [super initWithIdentifierManager:manager option:option];
    if(self){
        self.count = 4;
        [self.css setValue:@(500) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(300) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:[NSColor clearColor] forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        _selectColor = [NSColor blackColor];
        _deselectColor = [NSColor grayColor];
        _rightArrowImage = @"Default";
        _leftArrowImage = @"Default";
    }
    return self;
}

- (void)fetch{
    [super fetch];
    [self addObserver:self forKeyPath:@"css.assembledTagDictionary.height" options:0 context:
     @"height"];
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




-(void)setCount:(NSInteger)count{
    assert(self.identifierManager != nil);
    if (count == 0 || count > 30) {
        return;
    }
    while (_count > count) {
        [self removeIUAtIndex:[self.children count]-1];
        count++;
    }
    while (_count < count) {
        IUCarouselItem *item = [[IUCarouselItem alloc] initWithIdentifierManager:nil option:nil];
        [self.identifierManager setNewIdentifierAndRegister:item withKey:nil];
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
    NSString *itemID = [NSString stringWithFormat:@".%@pager-item", self.htmlID];
    NSString *hoverItemID = [NSString stringWithFormat:@".%@:hover", itemID];
    NSString *activeItemID = [NSString stringWithFormat:@".%@.active", itemID];
    
    if(self.enableColor){
        [self.delegate IUClassIdentifier:itemID CSSUpdated:[self.document.compiler cssContentForIUCarouselPager:self hover:NO] forWidth:IUCSSMaxViewPortWidth];
        
        [self.delegate IUClassIdentifier:hoverItemID CSSUpdated:[self.document.compiler cssContentForIUCarouselPager:self hover:YES] forWidth:IUCSSMaxViewPortWidth];
        
        [self.delegate IUClassIdentifier:activeItemID CSSUpdated:[self.document.compiler cssContentForIUCarouselPager:self hover:YES] forWidth:IUCSSMaxViewPortWidth];
    }
    else{
        [self.delegate IUClassIdentifier:itemID CSSRemovedforWidth:IUCSSMaxViewPortWidth];
        [self.delegate IUClassIdentifier:hoverItemID CSSRemovedforWidth:IUCSSMaxViewPortWidth];
        [self.delegate IUClassIdentifier:activeItemID CSSRemovedforWidth:IUCSSMaxViewPortWidth];
    }
    
}

- (void)heightContextDidChange:(NSDictionary *)change{
    //redraw arrowimage because of position
    [self setLeftArrowImage:_leftArrowImage];
    [self setRightArrowImage:_rightArrowImage];
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
        arrowID = @"bx-prev";
    }
    else if(type == IUCarouselArrowRight){
        arrowID = @"bx-next";
    }
    NSDictionary *dict = [self.document.compiler cssDictionaryForIUCarousel:self];
    for(NSString *identifier in dict.allKeys){
        if([identifier containsString:arrowID]){
            if(change){
                [self.delegate IUClassIdentifier:identifier CSSUpdated:[dict objectForKey:identifier] forWidth:self.css.editWidth];
            }
            else{
                [self.delegate IUClassIdentifier:identifier CSSRemovedforWidth:self.css.editWidth];
                
            }
            break;
        }
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