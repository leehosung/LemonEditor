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
#import "IUResourceNode.h"

@implementation IUResourceGroupNode{
}



- (BOOL)syncDir{
    return [JDFileUtil mkdirPath:self.absolutePath];
}

-(NSString*)relativePath{
    if ([_parent isKindOfClass:[IUProject class]]) {
        return [NSString stringWithFormat:@"./%@", self.name];
    }
    else{
        return [[(IUResourceGroupNode*)(_parent) relativePath] stringByAppendingPathComponent:self.name];
    }
}

-(NSString*)absolutePath{
    if ([_parent isKindOfClass:[IUProject class]]) {
        return [(IUProject*)(_parent) path];
    }
    else{
        return [[(IUResourceGroupNode*)(_parent) absolutePath] stringByAppendingPathComponent:self.name];
    }
}



@end
