//
//  IUResourceGroup.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IUResourceGroup : NSTreeNode <NSCoding>

@property NSString  *name;

- (BOOL)syncDir;
- (NSString*)path;
@end