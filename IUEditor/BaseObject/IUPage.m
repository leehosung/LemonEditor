//
//  IUPage.m
//  IUEditor
//
//  Created by jd on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPage.h"
#import "IUBackground.h"
#import "IUPageContent.h"

@implementation IUPage{
    IUPageContent *_pageContent;
    IUBackground *_background;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_pageContent forKey:@"pageContent"];
    [aCoder encodeObject:_background forKey:@"background"];
    [aCoder encodeFromObject:self withProperties:[IUPage properties]];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[IUPage properties]];
    _pageContent = [aDecoder decodeObjectForKey:@"pageContent"];
    _background = [aDecoder decodeObjectForKey:@"background"];
    [_pageContent bind:@"delegate" toObject:self withKeyPath:@"delegate" options:nil];
    [_background bind:@"delegate" toObject:self withKeyPath:@"delegate" options:nil];
    return self;
}

- (BOOL)floatRightChangeable{
    return NO;
}


- (BOOL)overflowChangeable{
    return NO;
}

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.css eradicateTag:IUCSSTagX];
        [self.css eradicateTag:IUCSSTagY];
        [self.css eradicateTag:IUCSSTagWidth];
        [self.css eradicateTag:IUCSSTagHeight];
    }
    return self;
}

-(IUBackground*)background{
    for (IUBox *obj in self.children) {
        if ([obj isKindOfClass:[IUBackground class]]) {
            return (IUBackground*)obj;
        }
    }
    return nil;
}

-(void)setBackground:(IUBackground *)background{
    assert(background.children);
    IUBackground *myBackground = self.background;
    
    if (myBackground == background) {
        return;
    }
    if (myBackground == nil && background ) {
        _background = background;
        NSArray *children = [self.children copy];
        _pageContent = [[IUPageContent alloc] initWithProject:self.project options:nil];
        _pageContent.htmlID = @"pageContent";
        _pageContent.name = @"pageContent";
        _pageContent.parent = self;
        
        for (IUBox *iu in children) {
            if (iu == (IUBox*)myBackground) {
                continue;
            }
            IUBox *temp = iu;
            [self removeIU:temp];
            [_pageContent addIU:temp error:nil];
        }
    }
    else if (myBackground && background == nil){
        NSArray *children = _pageContent.children;
        for (IUBox *iu in children) {
            [_pageContent removeIU:iu];
        }
    }
    else {
//        [self insertIU:background atIndex:0 error:nil];
    }
    _background = background;
    _background.parent = self;
    [_pageContent bind:@"delegate" toObject:self withKeyPath:@"delegate" options:nil];
    [_background bind:@"delegate" toObject:self withKeyPath:@"delegate" options:nil];
}

- (NSArray*)children{
    if (_pageContent && _background) {
        return @[_pageContent, _background];
    }
    else {
        return nil;
    }
}

- (BOOL)addIU:(IUBox *)iu error:(NSError *__autoreleasing *)error{
    assert(0);
    return YES;
}

-(void)CSSUpdated:(IUCSSTag)tag forWidth:(NSInteger)width isHover:(BOOL)isHover{
    [super CSSUpdated:tag forWidth:width isHover:isHover];
    if([tag  isEqual: IUCSSTagHeight]){
        CGFloat height = [[self.css tagDictionaryForWidth:width][IUCSSTagHeight] floatValue];
        [self.delegate changeIUPageHeight:height];
    }
}

-(BOOL)shouldRemoveIU{
    return NO;
}
@end