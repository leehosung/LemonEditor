//
//  IUCompiler.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUBox.h"
#import "IUCompilerResourceSource.h"

@class IUDocument;
@class IUResourceManager;

typedef enum _IUCompilerType{
    IUCompilerTypeDefault,
}IUCompilerType;

@interface IUCompiler : NSObject

@property id <IUCompilerResourceSource> resourceSource;
//build source
-(NSString*)outputSource:(IUDocument*)document mqSizeArray:(NSArray *)mqSizeArray;
-(NSString *)outputHTML:(IUBox *)iu;

//editor source
-(NSString*)editorSource:(IUDocument*)document mqSizeArray:(NSArray *)mqSizeArray;
-(NSString*)editorHTML:(IUBox*)iu;

-(NSString*)CSSContentFromAttributes:(NSDictionary*)attributeDict ofClass:(IUBox*)obj isHover:(BOOL)isHover;
-(NSString*)fontCSSContentFromAttributes:(NSDictionary*)attributeDict;
@end