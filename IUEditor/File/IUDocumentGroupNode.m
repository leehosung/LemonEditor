//
//  IUDirectoryNode.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocumentGroupNode.h"
#import "IUDocumentController.h"
#import "IUDocumentNode.h"

@implementation IUDocumentGroupNode{
}


-(void)addDocument:(IUDocument*)document name:(NSString*)name{
    //should be called from IUProject
    IUDocumentNode *node = [[IUDocumentNode alloc] init];
    node.document = document;
    node.name = name;
    [self addNode:node];
}

-(void)addDocumentGroupNode:(IUDocumentGroupNode*)node{
    [self addNode:node];
}

-(NSArray*)allDocuments{
    NSMutableArray *array = [NSMutableArray array];
    for (IUDocumentNode *node in self.children) {
        [array addObject:node.document];
    }
    return [array copy];
}
@end
