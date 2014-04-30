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

- (BOOL)flow{
    return YES;
}

-(BOOL)shouldRemoveIU{
    return NO;
}

-(BOOL)shouldEditText{
    return NO;
}

@end
