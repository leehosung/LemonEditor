//
//  IUDocumentNode.m
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocumentGroup.h"
#import "IUDocument.h"

@implementation IUDocumentGroup{
    NSMutableArray *_children;
}

- (id)init{
    self = [super init];
    _children = [NSMutableArray array];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    [aDecoder decodeToObject:self withProperties:[IUDocumentGroup properties]];
    _children = [[aDecoder decodeObjectForKey:@"_children"] mutableCopy];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeFromObject:self withProperties:[IUDocumentGroup properties]];
    [aCoder encodeObject:_children forKey:@"_children"];
}

- (NSArray*)children{
    return _children;
}

- (IUProject*)parent{
    return _project;
}

- (void)addDocument:(IUDocument*)document{
    document.group = self;
    [_children addObject:document];
}


@end
