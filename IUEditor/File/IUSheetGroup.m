//
//  IUSheetGroup.m
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUSheetGroup.h"
#import "IUSheet.h"
#import "IUProject.h"

@implementation IUSheetGroup{
    NSMutableArray *_children;
}

- (id)init{
    self = [super init];
    _children = [NSMutableArray array];
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IUSheetGroup *group = [[IUSheetGroup allocWithZone:zone] init];
    for (IUSheet *sheet in self.childrenFiles) {
        [group addSheet:sheet];
    }
    group.project = self.project;
    group.name = self.name;
    return group;
}

- (void)setChildren:(NSArray*)children{
    _children = [children mutableCopy];
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

- (void)changeIndex:(IUSheet *)sheet toIndex:(NSUInteger)newIndex{
    [_children removeObject:sheet];
    [_children insertObject:sheet atIndex:newIndex];
}

@end
