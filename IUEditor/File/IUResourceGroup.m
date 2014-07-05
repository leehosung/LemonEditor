 //
//  IUResourceGroup.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResourceGroup.h"
#import "IUResourceFile.h"
#import "JDFileUtil.h"
#import "IUProject.h"

@implementation IUResourceGroup{
    NSMutableArray *array;
}

-(id)init{
    self = [super init];
    array = [NSMutableArray array];
    return self;
}

- (void)setArray:(NSArray*)_array{
    array = [[_array deepCopy] mutableCopy];
}

- (id)copyWithZone:(NSZone *)zone{
    IUResourceGroup *returnGroup = [[IUResourceGroup allocWithZone:zone] init];
    returnGroup.name = self.name;
    [returnGroup setArray:array];
    for (id obj in returnGroup.childrenFiles) {
        [obj setParent:returnGroup];
    }
    return returnGroup;
}

- (BOOL)addResourceGroup:(IUResourceGroup*)group{
    [array addObject:group];
    group.parent = self;
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:array forKey:@"array"];
    [aCoder encodeObject:_name forKey:@"_name"];
    [aCoder encodeObject:_parent forKey:@"_parent"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    array = [[aDecoder decodeObjectForKey:@"array"] mutableCopy];
    _name = [aDecoder decodeObjectForKey:@"_name"];
    _parent = [aDecoder decodeObjectForKey:@"_parent"];
    return self;
}

- (BOOL)removeResourceFile:(IUResourceFile*)file{
    if ([array containsObject:file] == NO) {
        NSAssert(0, @"Can not file resource file");
    }
    file.parent = nil;
    [array removeObject:file];
    return YES;
}


-(NSString*)relativePath{
    if ([self.parent isKindOfClass:[IUProject class]]) {
        return self.name;
    }

    return [[self.parent relativePath] stringByAppendingPathComponent:self.name];
}

-(NSString*)absolutePath{
    if ([self.parent isKindOfClass:[IUProject class]]) {
        return [((IUProject*)self.parent).path stringByAppendingPathComponent:self.name];
    }
    return [[self.parent absolutePath] stringByAppendingPathComponent:self.name];
}

- (NSArray*)childrenFiles{
    return array;
}

-(IUResourceFile*)addResourceFileWithContentOfPath:(NSString*)filePath{
    IUResourceFile *file = [[IUResourceFile alloc] initWithName:filePath.lastPathComponent];
    file.originalFilePath = filePath;
    file.parent = self;
    [array addObject:file];
    
//    [[[NSApp mainWindow] windowController] saveDocument:self];

    return file;
}

/*
-(IUResourceFile*)addResourceFileWithData:(NSData*)data{
    IUResourceFile *file = [[IUResourceFile alloc] init];
    [array addObject:file];
    file.parent = self;
    NSAssert([[NSFileManager defaultManager] createFileAtPath:file.absolutePath contents:data attributes:nil]);
    return file;
}
 */

@end
