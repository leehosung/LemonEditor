//
//  LMCanvasViewController.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "IUSheet.h"
#import "IUController.h"
#import "IUResourceManager.h"

@class LMCanvasView;
@interface LMCanvasVC : NSViewController <IUSourceDelegate>

@property (nonatomic) _binding_ IUSheet  *sheet;
@property (nonatomic) _binding_ NSString    *documentBasePath;
@property (nonatomic) IUResourceManager  *resourceManager;

@property (nonatomic) IUController  *controller;

@property NSInteger selectedFrameWidth;
@property NSInteger maxFrameWidth;

- (void)addFrame:(NSInteger)frameSize;

#pragma mark -
#pragma mark call by sizeView
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
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION

- (void)updateNewline:(NSRange)range identifier:(NSString *)identifier htmlNode:(DOMHTMLElement *)node;
- (void)selectTextRange:(NSRange)range identifier:(NSString *)identifier htmlNode:(DOMHTMLElement *)node;

#endif
/*
- (void)selectTextRange:(NSRange)range identifier:(NSString *)identifier;
- (void)insertString:(NSString *)string identifier:(NSString *)identifier withRange:(NSRange)range;
- (void)deleteStringRange:(NSRange)range identifier:(NSString *)identifier;
*/
#pragma mark -
#pragma mark be set by IU
//load page
- (void)setSheet:(IUSheet *)sheet;
- (void)reloadSheet;

#pragma mark -
#pragma mark set IU

- (void)updateIUPercentFrameDictionary:(NSMutableDictionary *)iuFrameDict;
- (void)updateIUFrameDictionary:(NSMutableDictionary *)iuFrameDict;
- (void)updateGridFrameDictionary:(NSMutableDictionary *)gridFrameDict;

- (void)moveIUToDiffPoint:(NSPoint)point totalDiffPoint:(NSPoint)totalPoint;
- (void)startDragSession:(id)sender;
- (void)extendIUToDiffSize:(NSSize)size totalDiffSize:(NSSize)totalSize;
- (BOOL)checkExtendSelectedIU:(NSSize)size;


- (BOOL)makeNewIUByDragAndDrop:(IUBox *)newIU atPoint:(NSPoint)point atIU:(NSString *)parentIUID;
- (NSString *)currentHTML;

- (void)copy:(id)sender;
- (void)paste:(id)sender;

#if DEBUG
- (void)applyHtmlString:(NSString *)html;
- (void)reloadOriginalDocument;

#endif

- (void)performRightClick:(NSString*)IUID withEvent:(NSEvent*)event;
@end
