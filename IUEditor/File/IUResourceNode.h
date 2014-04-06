//
//  IUResourceNode.h
//  IUEditor
//
//  Created by JD on 3/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUNode.h"
#import "IUResourceGroupNode.h"

typedef enum _IUResourceNodeType{
    IUResourceNodeTypeImage = 1,
    IUResourceNodeTypeMovie,
    IUResourceNodeTypeCSS,
    IUResourceNodeTypeJS,
}IUResourceNodeType;

@interface IUResourceNode : IUNode


-(id)initWithName:(NSString*)name parent:(IUResourceGroupNode*)group type:(IUResourceNodeType)type;

-(IUResourceGroupNode*)parent;
-(NSString*)absolutePath;
-(NSString*)relativePath;

-(NSImage*)image;
-(NSString*)UTI;
-(IUResourceNodeType)type;

@end
