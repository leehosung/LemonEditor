//
//  IUPage.m
//  IUEditor
//
//  Created by jd on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPage.h"

@implementation IUPage

- (void)setATemplate:(IUTemplate *)aTemplate{
    
}

- (id)initWithSetting:(NSDictionary *)setting{
    self = [super initWithSetting:setting];
    
    //add some iu
    IUObj *obj = [[IUObj alloc] initWithSetting:nil];
    obj.htmlID = @"qwerq";
    obj.name = @"sample object";
    [self addIU:obj error:nil];
    
    [self.css removeStyle:IUCSSTagFrameCollection];
    return self;
}

@end