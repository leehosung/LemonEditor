//
//  IUResourceGroup.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResourceGroupNode.h"
#import "IUProject.h"
#import "JDFileUtil.h"

@implementation IUResourceGroupNode{
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
        return [[(IUResourceGroupNode*)(_parent) path] stringByAppendingPathComponent:self.name];
    }
}

@end
