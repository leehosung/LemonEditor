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

@class LMCanvasView;
@interface LMCanvasVC : NSViewController <IUSourceDelegate>

@property (nonatomic) _binding_ IUDocument  *document;
@property (nonatomic) _binding_ NSString    *documentBasePath;
@property (nonatomic) IUController  *controller;

@property _observing_ NSInteger selectedFrameWidth;
@property _observing_ NSInteger maxFrameWidth;


- (LMCanvasView*)view;

#pragma mark -
//border, ghost view
- (void)setBorder:(BOOL)border;
- (void)setGhost:(BOOL)ghost;
- (void)setGhostImage:(NSImage *)ghostImage;
- (void)setGhostPosition:(NSPoint)position;

#pragma mark -
#pragma mark call by sizeView

- (void)refreshGridFrameDictionary;

//set frame size
- (NSInteger)frameWidth;
- (id)addFrame:(NSInteger)width;
- (void)removeFrame:(NSInteger)width;


#pragma mark -
#pragma mark call by webView
- (void)removeSelectedIUs;
- (void)insertImage:(NSString *)path atIU:(NSString *)identifier;

//select IUs
- (BOOL)containsIU:(NSString *)IUID;
- (NSUInteger)countOfSelectedIUs;
- (void)deselectedAllIUs;
- (void)addSelectedIU:(NSString *)IU;
- (void)selectIUInRect:(NSRect)frame;


#pragma mark -
#pragma mark be set by IU
//load page
- (void)setDocument:(IUDocument *)document;


//set html
- (void)removeIU:(NSString *)iuID;


#pragma mark -
#pragma mark set IU

- (void)updateIUFrameDictionary:(NSMutableDictionary *)iuFrameDict;
- (void)updateGridFrameDictionary:(NSMutableDictionary *)gridFrameDict;
- (void)updateHTMLText:(NSString *)insertText atIU:(NSString *)iuID;

- (void)moveIUToDiffPoint:(NSPoint)point totalDiffPoint:(NSPoint)totalPoint;
- (void)extendIUToDiffSize:(NSSize)size totalDiffSize:(NSSize)totalSize;
- (BOOL)checkExtendSelectedIU:(NSSize)size;


- (void)makeNewIU:(IUBox *)newIU atPoint:(NSPoint)point atIU:(NSString *)parentIUID;
- (NSString *)currentHTML;

- (void)showCurrentSource;

@end
