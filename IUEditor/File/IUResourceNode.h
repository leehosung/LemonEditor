//
//  IUResourceNode.h
//  IUEditor
//
//  Created by JD on 3/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUNode.h"
#import "IUResourceGroupNode.h"

typedef enum _IUResourceType{
    IUResourceTypeImage,
    IUResourceTypeCSS,
    IUResourceTypeJS,
}IUResourceType;


@interface IUResourceNode : IUNode

@property IUResourceGroupNode *parent;

-(id)initWithName:(NSString*)name type:(IUResourceType)type;

-(NSString*)absolutePath;
-(NSString*)relativePath;

-(NSImage*)image;
-(NSString*)UTI;
-(IUResourceType)type;

@end
