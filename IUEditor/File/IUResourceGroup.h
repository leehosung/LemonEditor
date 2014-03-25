//
//  IUResourceGroup.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUNode.h"

@interface IUResourceGroup : NSObject <IUNode, NSCoding>

@property id <IUNode>  parent;
@property NSString      *name;
@property (nonatomic, readonly) NSMutableArray *children;

- (BOOL)syncDir;
- (NSString*)path;

@end