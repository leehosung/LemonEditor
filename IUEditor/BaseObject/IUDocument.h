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

@protocol IUDocumentDelegate <NSObject>
@required
-(void)updateIU:(NSString*)identifier html:(NSString*)html;
-(void)updateIU:(NSString*)identifier css:(NSString*)css forWidth:(int)width;
-(void)addIU:(NSString*)identifier parentIU:(NSString*)parentIdentifier index:(NSInteger)index css:(NSString*)css html:(NSString*)html;
-(void)removeIU:(NSString*)identifier;
@end


@interface IUDocument : IUView


#pragma mark editor source
-(NSString*)editorSource;

//-(NSString*)outputSource;

-(NSArray*)widthWithCSS;
-(IUObj *)selectableIUAtPoint:(CGPoint)point;


#pragma mark Reference Management



@property id <IUDocumentDelegate> canvas;
@end