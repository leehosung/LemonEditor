//
//  IUSheetGroup.m
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUSheetGroup.h"
#import "IUSheet.h"

@implementation IUSheetGroup{
    NSMutableArray *_children;
}

- (id)init{
    self = [super init];
    _children = [NSMutableArray array];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    [aDecoder decodeToObject:self withProperties:[IUSheetGroup properties]];
    _children = [[aDecoder decodeObjectForKey:@"_children"] mutableCopy];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeFromObject:self withProperties:[IUSheetGroup properties]];
    [aCoder encodeObject:_children forKey:@"_children"];
}

- (NSArray*)childrenFiles{
    return _children;
}

- (IUProject*)parent{
    return _project;
}

- (void)addSheet:(IUSheet*)sheet{
    sheet.group = self;
    [_children addObject:sheet];
}

- (void)removeSheet:(IUSheet *)sheet{
    assert([_children containsObject:sheet]);
    [_children removeObject:sheet];
}

@end
