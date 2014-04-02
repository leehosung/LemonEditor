//
//  LMWC.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUDocumentController.h"
#import "WebCanvasView.h"
#import "IUFrameDictionary.h"


@interface LMWC : NSWindowController <NSWindowDelegate>

@property (nonatomic) _binding_ IUNode *selectedNode;
@property (nonatomic) _binding_ id selectedIU;

-(void)loadProject:(NSString*)path;
-(void)startNewProject;


/*
 ***************************************************************************************************
 ****************************************** Canvas Window ******************************************
 ***************************************************************************************************
 */

#pragma mark -
#pragma mark CanvasWindow Controller

#pragma mark -
#pragma mark be set by IU

//set frame size
- (void)addFrame:(NSInteger)width;
- (void)removeFrame:(NSInteger)width;

//load page
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)htmlString baseURL:(NSURL *)URL;

//select IUs
- (BOOL)containsIU:(NSString *)IU;
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

- (void)moveDiffPoint:(NSPoint)point;
- (void)changeIUFrame:(NSRect)frame IUID:(NSString *)IUID;

- (void)makeNewIU:(NSString *)iuname atPoint:(NSPoint)point atIU:(NSString *)IU;


@end
