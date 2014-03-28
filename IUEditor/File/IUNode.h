//
//  IUNode.h
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUNode : NSObject <NSCoding>

@property (copy) NSString   *name;
@property (readonly) NSArray *children;

-(void)addNode:(IUNode*)node;
-(NSArray*)allChildren;

@end
