//
//  IUTransition.m
//  IUEditor
//
//  Created by jd on 4/22/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUTransition.h"
#import "IUItem.h"

@interface IUTransition()
@property IUItem *firstItem;
@property IUItem *secondItem;
@end


@implementation IUTransition{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[IUTransition properties]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[IUTransition properties]];
}

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    _firstItem = [[IUItem alloc] initWithProject:project options:options];
    _secondItem = [[IUItem alloc] initWithProject:project options:options];
    [_secondItem.css setValue:@(NO) forTag:IUCSSTagDisplay];
    
    [self addIU:_firstItem error:nil];
    [self addIU:_secondItem error:nil];
    self.currentEdit = 0;
    self.eventType = @"Click";
    self.animation = @"Blind";
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IUTransition *iu = [super copyWithZone:zone];
    iu.currentEdit = _currentEdit;
    iu.eventType = [_eventType copy];
    iu.animation = [_animation copy];
    return iu;
}
- (void)connectWithEditor{
    [super connectWithEditor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionChanged:) name:IUNotificationSelectionDidChange object:nil];

}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)selectionChanged:(NSNotification*)noti{
    NSMutableSet *set = [NSMutableSet setWithArray:self.children];
    [set intersectSet:[NSSet setWithArray:[noti userInfo][@"selectedObjects"]]];
    if ([set count] != 1) {
        return;
    }
    IUBox *box = [set anyObject];
    if (box == _firstItem) {
        [self setCurrentEdit:0];
    }
    else {
        [self setCurrentEdit:1];
    }
}


- (void)setHtmlID:(NSString *)htmlID{
    [super setHtmlID:htmlID];
    _firstItem.htmlID = [htmlID stringByAppendingString:@"Item1"];
    _firstItem.name = _firstItem.htmlID;
    _secondItem.htmlID = [htmlID stringByAppendingString:@"Item2"];
    _secondItem.name = _secondItem.htmlID;
}

- (void)setCurrentEdit:(NSInteger)currentEdit{
    _currentEdit = currentEdit;
    if (currentEdit == 0) {
        [_firstItem.css setValue:@(YES) forTag:IUCSSTagDisplay];
        [_secondItem.css setValue:@(NO) forTag:IUCSSTagDisplay];
    }
    else {
        [_firstItem.css setValue:@(NO) forTag:IUCSSTagDisplay];
        [_secondItem.css setValue:@(YES) forTag:IUCSSTagDisplay];
    }
}

@end
