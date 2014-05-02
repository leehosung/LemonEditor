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
    IUPageContent *pageContent;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[IUPage properties]];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[IUPage properties]];
    
    [self addObserver:self.css.assembledTagDictionary forKeyPath:@"css" options:0 context:nil];

    return self;
}

- (id)initWithManager:(IUIdentifierManager *)manager option:(NSDictionary *)option{
    self = [super initWithManager:manager option:option];
    
    //add some iu
    IUBox *obj = [[IUBox alloc] initWithManager:manager option:option];
    obj.htmlID = @"qwerq";
    obj.name = @"sample object";
    [self addIU:obj error:nil];
    
    [self.css eradicateTag:IUCSSTagX];
    [self.css eradicateTag:IUCSSTagY];
    [self.css eradicateTag:IUCSSTagWidth];
    [self.css eradicateTag:IUCSSTagHeight];
    
    return self;
}
-(BOOL)shouldEditText{
    return NO;
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
    IUBackground *myBackground = self.background;
    
    if (myBackground == background) {
        return;
    }
    if (myBackground == nil && background ) {
        NSArray *children = [self.children copy];
        pageContent = [[IUPageContent alloc] initWithManager:nil option:nil];
        pageContent.htmlID = @"pageContent";
        pageContent.name = @"pageContent";
        
        for (IUBox *iu in children) {
            if (iu == (IUBox*)myBackground) {
                continue;
            }
            IUBox *temp = iu;
            [self removeIU:temp];
            [pageContent addIU:temp error:nil];
        }
        
        [self addIU:background error:nil];
        [self addIU:pageContent error:nil];
    }
    else if (myBackground && background == nil){
        NSArray *children = pageContent.children;
        [self removeIU:background];
        [self removeIU:pageContent];
        for (IUBox *iu in children) {
            [pageContent removeIU:iu];
            [self addIU:iu error:nil];
        }
    }
    else {
        [self removeIU:self.background];
        [self insertIU:background atIndex:0 error:nil];
    }
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