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

-(IUResourceGroup *)addResourceGroupWithName:(NSString*)groupName{
    IUResourceGroup *group = [[IUResourceGroup alloc] init];
    [array addObject:group];
    group.name = groupName;
    group.parent = self;
    return group;
}

-(IUResourceFile*)addResourceFileWithContentOfPath:(NSString*)filePath{
    IUResourceFile *file = [[IUResourceFile alloc] initWithName:filePath.lastPathComponent];
    file.originalFilePath = filePath;
    file.parent = self;
    [array addObject:file];
    
    [[[NSApp mainWindow] windowController] saveDocument:self];

    return file;
}

/*
-(IUResourceFile*)addResourceFileWithData:(NSData*)data{
    IUResourceFile *file = [[IUResourceFile alloc] init];
    [array addObject:file];
    file.parent = self;
    assert([[NSFileManager defaultManager] createFileAtPath:file.absolutePath contents:data attributes:nil]);
    return file;
}
 */

@end
