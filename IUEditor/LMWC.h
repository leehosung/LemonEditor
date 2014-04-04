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
@class LMWindow;

@interface LMWC : NSWindowController <NSWindowDelegate>

@property (nonatomic) _binding_ IUNode *selectedNode;
@property  _binding_ NSTreeController   *IUController;

-(void)loadProject:(NSString*)path;
-(void)startNewProject;

-(void)setSelectedObjectsByName:(NSArray *)selectedNames;

@end