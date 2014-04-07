//
//  IUManager.m
//  IUEditor
//
//  Created by jd on 4/7/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUManager.h"
#import "IUObj.h"

@implementation IUManager{
    NSMutableSet *set;
}

-(id)init{
    self = [super init];
    set = [NSMutableSet set];
    return self;
}


-(void)registerIU:(IUObj*)iu{
    [set addObject:iu];
    [set addObjectsFromArray:iu.allChildren];
}

-(NSString*)requestNewIDWithIdentifier:(NSString*)identifier{
    return @"qwer";
}

@end