//
//  IUHTML.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 15..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUHTML.h"

@implementation IUHTML

-(id)initWithManager:(IUIdentifierManager*)manager{
    self = [super initWithManager:manager];
    if(self){
        self.innerHTML = @"<div>test</div>";
    }
    return self;
}

-(BOOL)shouldADDIU{
    return NO;
}

-(BOOL)hasInnerHTML{
    return YES;
}

@end
