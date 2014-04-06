//
//  IUResourceGroup.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUNode.h"

@interface IUResourceGroupNode : IUNode

@property (nonatomic) IUNode    *parent;
- (BOOL)syncDir;
- (NSString*)relativePath;
- (NSString*)absolutePath;

@end