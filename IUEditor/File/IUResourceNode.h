//
//  IUResourceNode.h
//  IUEditor
//
//  Created by JD on 3/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUNode.h"
#import "IUResourceGroupNode.h"

@interface IUResourceNode : IUNode


-(id)initWithName:(NSString*)name parent:(IUResourceGroupNode*)group;

-(IUResourceGroupNode*)parent;
-(NSString*)path;
-(NSImage*)image;
-(NSString*)UTI;


@end
