//
//  IUCompiler.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUObj.h"

@class IUDocument;

typedef enum _IUCompilerType{
    IUCompilerTypeDefault,
}IUCompilerType;

@interface IUCompiler : NSObject

-(NSString*)editorSource:(IUDocument*)document;

-(NSString*)editorHTML:(IUObj*)iu;
-(NSString*)CSSContentFromAttributes:(NSDictionary*)attributeDict ofClass:(IUObj*)obj;

@property NSDictionary  *resourcePaths;
@end