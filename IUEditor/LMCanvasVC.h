//
//  LMCanvasViewController.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUDocument.h"
#import "IUController.h"
#import "IUResourceManager.h"

@class LMCanvasView;
@interface LMCanvasVC : NSViewController <IUSourceDelegate>

@property (nonatomic) _binding_ IUDocument  *document;
@property (nonatomic) _binding_ NSString    *documentBasePath;
@property (nonatomic) IUResourceManager  *resourceManager;

@property (nonatomic) IUController  *controller;

@property _observing_ NSInteger selectedFrameWidth;
@property _observing_ NSInteger maxFrameWidth;

- (LMCanvasView*)view;
- (void)addFrame:(NSInteger)frameSize;

#pragma mark -
#pragma mark call by sizeView

- (void)refreshGridFrameDictionary;
- (void)removeStyleSheet:(NSInteger)size;

#pragma mark -
#pragma mark call by webView
- (void)removeSelectedIUs;
- (void)insertImage:(NSString *)name atIU:(NSString *)identifier;

//select IUs
- (BOOL)containsIU:(NSString *)IUID;
- (BOOL)isEditable;
- (NSString *)selectedIUIdentifier;
- (NSUInteger)countOfSelectedIUs;
- (void)deselectedAllIUs;
- (void)addSelectedIU:(NSString *)IU;
- (void)removeSelectedIU:(NSString *)IU;
- (void)setSelectedIU:(NSString *)IU;
- (void)selectIUInRect:(NSRect)frame;

//text
- (void)selectTextRange:(NSRange)range identifier:(NSString *)identifier;
- (void)insertString:(NSString *)string identifier:(NSString *)identifier withRange:(NSRange)range;
- (void)deleteStringRange:(NSRange)range identifier:(NSString *)identifier;

#pragma mark -
#pragma mark be set by IU
//load page
- (void)setDocument:(IUDocument *)document;

#pragma mark -
#pragma mark set IU

- (void)updateIUPercentFrameDictionary:(NSMutableDictionary *)iuFrameDict;
- (void)updateIUFrameDictionary:(NSMutableDictionary *)iuFrameDict;
- (void)updateGridFrameDictionary:(NSMutableDictionary *)gridFrameDict;

- (void)moveIUToDiffPoint:(NSPoint)point totalDiffPoint:(NSPoint)totalPoint;
- (void)startDragSession;
- (void)extendIUToDiffSize:(NSSize)size totalDiffSize:(NSSize)totalSize;
- (BOOL)checkExtendSelectedIU:(NSSize)size;


- (BOOL)makeNewIUByDragAndDrop:(IUBox *)newIU atPoint:(NSPoint)point atIU:(NSString *)parentIUID;
- (NSString *)currentHTML;

- (void)copy:(id)sender;
- (void)paste:(id)sender repeatCount:(NSInteger)repeatCount;
@end
