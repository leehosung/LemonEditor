//
//  IUGroupNode.h
//  IUEditor
//
//  Created by JD on 4/6/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUNode.h"

@interface IUGroupNode : IUNode

//KVOCompliance
-(NSArray*)children;
-(NSArray*)allChildren;
-(void)addNode:(IUNode*)node;
-(void)removeNode:(IUNode*)node;
-(BOOL)containName:(NSString *)name;

@end