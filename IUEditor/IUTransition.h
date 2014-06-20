//
//  IUTransition.h
//  IUEditor
//
//  Created by jd on 4/22/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBox.h"

static NSString * kIUTransitionEventMouseOn = @"Mouse On";
static NSString * kIUTransitionEventClick = @"Click";

@interface IUTransition : IUBox

@property (nonatomic) NSInteger currentEdit;
@property (nonatomic) NSString  *eventType;
@property (nonatomic) NSString  *animation;

@end