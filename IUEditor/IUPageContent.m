//
//  IUPageContent.m
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPageContent.h"

@implementation IUPageContent

-(BOOL)hasX{
    return NO;
}
-(BOOL)hasY{
    return NO;
}
-(BOOL)hasWidth{
    return NO;
}
-(BOOL)hasHeight{
    return NO;
}

-(BOOL)shouldRemoveIU{
    return NO;
}

- (BOOL)canChangePositionType{
    return NO;
}

- (BOOL)canChangeHelpMenu{
    return NO;
}

- (BOOL)canChangeOverflow{
    return NO;
}

- (BOOL)canChangeXByUserInput{
    return NO;
}
- (BOOL)canChangeYByUserInput{
    return NO;
}
- (BOOL)canChangeWidthByUserInput{
    return NO;
}

- (BOOL)canChangeHeightByUserInput{
    return NO;
}


-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width{
    NSMutableDictionary *dict = [[super CSSAttributesForWidth:width ] mutableCopy];
    [dict setObject:@(width) forKey:@"min-width"];
    return dict;
}



@end
