//
//  IUResourceGroup.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResourceGroup.h"
#import "IUProject.h"
#import "JDFileUtil.h"

@implementation IUResourceGroup

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:@"name"];
}

- (BOOL)syncDir{
    return [JDFileUtil mkdirPath:self.path];
}

-(NSString*)path{
    if ([self.parentNode isKindOfClass:[IUProject class]]) {
        NSString *parentPath = [(IUProject*)(self.parentNode) dirPath];
        return [parentPath stringByAppendingPathComponent:_name];
    }
    else{
        return [[(IUResourceGroup*)self.parentNode path] stringByAppendingPathComponent:_name];
    }
}

@end
