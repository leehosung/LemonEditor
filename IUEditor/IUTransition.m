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

- (id)initWithManager:(IUIdentifierManager *)identifierManager{
    self = [super initWithManager:identifierManager];
    _firstItem = [[IUItem alloc] initWithManager:identifierManager];
    _firstItem.htmlID = @"_temp_item1";
    _secondItem = [[IUItem alloc] initWithManager:identifierManager];
    _secondItem.htmlID = @"_temp_item2";
    [_secondItem.css setValue:@(YES) forTag:IUCSSTagHidden];
    
    [self addIU:_firstItem error:nil];
    [self addIU:_secondItem error:nil];
    self.currentEdit = 0;
    self.event = @"Click";
    self.animation = @"Overlap";
    return self;
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
        [_firstItem.css setValue:@(NO) forTag:IUCSSTagHidden];
        [_secondItem.css setValue:@(YES) forTag:IUCSSTagHidden];
    }
    else {
        [_firstItem.css setValue:@(YES) forTag:IUCSSTagHidden];
        [_secondItem.css setValue:@(NO) forTag:IUCSSTagHidden];
    }
}

@end
