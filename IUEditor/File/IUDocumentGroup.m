//
//  IUDirectoryNode.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocumentGroup.h"
#import "IUDocumentController.h"

@implementation IUDocumentGroup{
}

- (void)encodeWithCoder:(NSCoder *)encoder{
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
    }
    return self;
}

- (id)init{
    self = [super init];
    _children = [NSMutableArray array];
    return self;
}


-(void)addDocument:(IUDocument*)document{
    [self.children addObject:document];
}

-(void)addDocumentGroup:(IUDocumentGroup*)node{
    [self.children addObject:node];
}

@end
