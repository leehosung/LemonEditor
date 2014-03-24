//
//  IUFileNode.m
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocumentNode.h"

@implementation IUDocumentNode{
    NSMutableArray  *_children;
}

-(id)init{
    self = [super init];
    if (self) {
        _children = [NSMutableArray array];
    }
    return self;
}


-(NSMutableArray*)children{
    return _children;
}

@end
