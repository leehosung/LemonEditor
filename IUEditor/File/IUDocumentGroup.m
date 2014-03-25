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
    [encoder encodeFromObject:self withProperties:[IUDocumentGroup properties]];
    [encoder encodeObject:self.children forKey:@"children"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
        _children = [NSMutableArray array];

        [aDecoder decodeToObject:self withProperties:[IUDocumentGroup properties]];
        NSArray *array = [aDecoder decodeObjectForKey:@"children"];
        [_children addObjectsFromArray:array];
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
