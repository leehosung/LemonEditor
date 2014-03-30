//
//  IUView.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUView.h"

@implementation IUView
-(BOOL)addIU:(IUObj *)iu error:(NSError**)error{
    [self.children addObject:iu];
    return YES;
}
@end
