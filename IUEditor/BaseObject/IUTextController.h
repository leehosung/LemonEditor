//
//  IUTextController.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 20..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "IUCSS.h"

@protocol IUTextControllerDelegate <NSObject>

@property (readonly) IUCSS *css;

- (NSString*)identifierForTextController;
- (void)updateTextHTML;
- (void)updateTextCSS:(IUCSS *)textCSS identifier:(NSString *)identifier;

@end


@interface IUTextController : NSObject <NSCopying, IUCSSDelegate>

@property (weak) id <IUTextControllerDelegate> textDelegate;

@property NSMutableDictionary *cssDict;

@property (nonatomic) NSColor *fontColor;
@property (nonatomic) BOOL bold, italic, underline;
@property (nonatomic) NSString *link;
@property (nonatomic) int fontSize;
@property (nonatomic) IUAlign textAlign;
@property (nonatomic) IUCSS *css;

- (void)selectTextRange:(NSRange)range startContainer:(NSString *)startContainer endContainer:(NSString *)endContainer htmlNode:(DOMHTMLElement *)node;
- (NSString *)textHTML;
-(void)setEditWidth:(NSInteger)width;

@end
