//
//  IUNode.h
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IUGroupNode;
@interface IUNode : NSObject <NSCoding>

@property (copy) NSString   *name;
@property IUGroupNode       *parent;

- (BOOL)isLeaf;
- (IUGroupNode*)rootNode;
- (IUNode*)nodeWithName:(NSString*)name;
@end