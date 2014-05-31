//
//  IUDocument.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCompiler.h"
#import "IUBox.h"
#import "IUIdentifierManager.h"

@class IUDocumentGroup;

@interface IUDocument : IUBox

@property NSArray *mqSizeArray;

@property CGFloat ghostX, ghostY, ghostOpacity;
@property NSString *ghostImageName;

#pragma mark editor source
-(NSString*)editorSource;
-(NSString*)outputSource;
- (NSString*)outputInitJSSource;

-(NSArray*)widthWithCSS;
-(IUBox *)selectableIUAtPoint:(CGPoint)point;

@property IUDocumentGroup *group;

@end