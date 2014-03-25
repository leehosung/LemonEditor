//
//  IUDocument.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUView.h"

@protocol IUDocumentCanvas <NSObject>


@end


@interface IUDocument : IUView


-(id)initWithSetting:(NSDictionary*)setting;

//connect with controller
-(void)fetch;

-(NSString*)editorSource;
-(NSString*)outputSource;

-(NSArray*)widthWithCSS;
-(IUObj *)selectableIUAtPoint:(CGPoint)point;

-(void)addReferenceToIUDocument:(IUDocument*)document;
-(void)removeReferenceToIUDocument:(IUDocument*)document;

-(void)addReferenceFromIUDocument:(IUDocument*)document;
-(void)removeReferenceFromIUDocument:(IUDocument*)document;


-(NSArray*)outputCSSCollection;


@property id <IUDocumentCanvas> canvas;
@end