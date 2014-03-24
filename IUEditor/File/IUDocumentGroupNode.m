//
//  IUDirectoryNode.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocumentGroupNode.h"
#import "IUDocumentController.h"


@implementation IUDocumentGroupNode{
    id  _parent;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
    }
    return self;
}


-(void)addDocument:(IUDocument*)document{
    [self.children addObject:document];
}

-(void)addDocumentGroup:(IUDocumentGroupNode*)node{
    [self.children addObject:node];
}

@end
