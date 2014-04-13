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


@interface IUDocument : IUBox

@property IUCompiler *compiler;

#pragma mark editor source
-(NSString*)editorSource;

//-(NSString*)outputSource;

-(NSArray*)widthWithCSS;
-(IUBox *)selectableIUAtPoint:(CGPoint)point;



@end