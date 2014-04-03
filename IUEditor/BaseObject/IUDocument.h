//
//  IUDocument.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCompiler.h"
#import "IUView.h"

@protocol IUDocumentCanvas <NSObject>


@end


@interface IUDocument : IUView


#pragma mark editor source
-(NSString*)editorSource;

//-(NSString*)outputSource;

-(NSArray*)widthWithCSS;
-(IUObj *)selectableIUAtPoint:(CGPoint)point;


#pragma mark Reference Management



@property id <IUDocumentCanvas> canvas;
@end