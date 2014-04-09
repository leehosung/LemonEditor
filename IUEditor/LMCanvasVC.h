//
//  LMCanvasViewController.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUDocument.h"
#import "LMCanvasVCDelegate.h"

@class LMCanvasView;
@interface LMCanvasVC : NSViewController <IUSourceDelegate>

@property (nonatomic) _binding_ IUDocument  *document;
@property (nonatomic) _binding_ NSString    *documentBasePath;
@property (nonatomic) NSTreeController <LMCanvasVCDelegate> *controller;

@property _binding_ NSInteger selectedFrameWidth;
@property _binding_ NSInteger maxFrameWidth;


- (LMCanvasView*)view;
- (void)refreshGridFrameDictionary;
#pragma mark -
#pragma mark be set by IU

//set frame size
- (NSInteger)frameWidth;
- (id)addFrame:(NSInteger)width;
- (void)removeFrame:(NSInteger)width;

//load page
- (void)setDocument:(IUDocument *)document;

//select IUs
- (BOOL)containsIU:(NSString *)IUID;
- (NSUInteger)countOfSelectedIUs;
- (void)removeSelectedAllIUs;
- (void)addSelectedIU:(NSString *)IU;
- (void)selectIUInRect:(NSRect)frame;

//set css
/*
 cssText: #test2{background-color:green; width:100px; height:100px}
 */
- (void)setIUStyle:(NSString *)cssText withID:(NSString *)iuID;
- (void)setIUStyle:(NSString *)cssText withID:(NSString *)iuID size:(NSInteger)size;

//set html
- (void)setIUInnerHTML:(NSString *)HTML withParentID:(NSString *)parentID tag:(NSString *)tag;
- (void)removeIU:(NSString *)iuID;

//border, ghost view
- (void)setBorder:(BOOL)border;
- (void)setGhost:(BOOL)ghost;
- (void)setGhostImage:(NSImage *)ghostImage;
- (void)setGhostPosition:(NSPoint)position;


#pragma mark -
#pragma mark setIU
//TODO: connect to IU - set value to IU
- (void)updateIUFrameDictionary:(NSMutableDictionary *)iuFrameDict;
- (void)updateGridFrameDictionary:(NSMutableDictionary *)gridFrameDict;

- (void)updateHTMLText:(NSString *)insertText atIU:(NSString *)iuID;

- (void)moveIUToDiffPoint:(NSPoint)point totalDiffPoint:(NSPoint)totalPoint;
- (void)extendIUToDiffSize:(NSSize)size totalDiffSize:(NSSize)totalSize;;

- (void)makeNewIU:(NSString *)IUID atPoint:(NSPoint)point atIU:(NSString *)IU;

- (void)showCurrentSource;
@end
