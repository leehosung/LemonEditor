//
//  SelectionBorderLayer.m
//  IUEditor
//
//  Created by test on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "SelectionBorderLayer.h"

@implementation SelectionBorderLayer

- (id)initWithIUID:(NSString *)aIUID withFrame:(NSRect)frame{
    self = [super init];
    if(self){
        IUID = aIUID;
        
        [self setFrame:frame];
        
        
        [self setBorderColor:[[NSColor rgbColorRed:50 green:160 blue:240 alpha:0.5] CGColor]];
        self.borderWidth = 2.0f;
        [self disableAction];
        
    }
    return self;
}

- (NSString *)iuID{
    return IUID;
}


@end
