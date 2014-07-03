//
//  IUButton.m
//  IUEditor
//
//  Created by jd on 5/7/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "PGSubmitButton.h"

@implementation PGSubmitButton

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if (self) {
        self.label = @"Submit"; //place holder 초기값은 Submit
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[PGSubmitButton properties]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[PGSubmitButton properties]];
}

- (id)copyWithZone:(NSZone *)zone{
    PGSubmitButton *iu = [super copyWithZone:zone];
    iu.label = [_label copy];
    return iu;
}


- (void)setLabel:(NSString *)label{
    if (label == nil)
        _label = @"";   //place holder 에 빈칸 입력시 null 로 표시되는 것을 방지
    else
        _label = label;
    
    [self updateHTML];
    [self updateJS];
}


@end
