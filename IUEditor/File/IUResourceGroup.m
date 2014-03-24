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

@implementation IUResourceGroup{
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
}


- (BOOL)syncDir{
    return [JDFileUtil mkdirPath:self.path];
}

-(NSString*)path{
    if ([_parent isKindOfClass:[IUProject class]]) {
        NSString *parentPath = [(IUProject*)(_parent) path];
        return [parentPath stringByAppendingPathComponent:self.name];
    }
    else{
        return [[(IUResourceGroup*)(_parent) path] stringByAppendingPathComponent:self.name];
    }
}

@end
