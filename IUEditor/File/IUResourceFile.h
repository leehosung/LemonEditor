//
//  IUResourceNode.h
//  IUEditor
//
//  Created by JD on 3/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResourceGroup.h"

typedef enum _IUResourceType{
    IUResourceTypeNone,
    IUResourceTypeImage,
    IUResourceTypeCSS,
    IUResourceTypeJS,
    IUResourceTypeVideo,
}IUResourceType;


@interface IUResourceFile : NSObject

@property IUResourceGroup *parent;
@property NSString *originalFilePath;
-(id)initWithName:(NSString*)name;

-(NSString*)absolutePath;
-(NSString*)relativePath;

-(NSImage*)image;
-(IUResourceType)type;
-(NSString*)name;

@end
