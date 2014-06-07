//
//  IUHeader.m
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUHeader.h"

@implementation IUHeader

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    [self.css eradicateTag:IUCSSTagWidth];
    return self;
}

-(BOOL)shouldRemoveIU{
    return NO;
}

- (BOOL)flow{
    return YES;
}

- (BOOL)flowChangeable{
    return NO;
}

- (BOOL)hasX{
    return NO;
}

- (BOOL)hasY{
    return NO;
}

- (BOOL)hasWidth{
    return NO;
}

- (BOOL)floatRightChangeable{
    return NO;
}

- (BOOL)enableXUserInput{
    return NO;
}

- (BOOL)enableYUserInput{
    return NO;
}

- (BOOL)enableWidthUserInput{
    return NO;
}
@end
