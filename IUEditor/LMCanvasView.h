//
//  LMCanvasView.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SizeView.h"
#import "WebCanvasView.h"
#import "GridView.h"
#import "NSFlippedView.h"

@interface LMCanvasView : NSView

@property id delegate;

@property (weak) IBOutlet NSScrollView *mainScrollView;
@property  NSFlippedView *mainView;

@property WebCanvasView *webView;
@property GridView *gridView;

@property (weak) IBOutlet SizeView *sizeView;

- (BOOL)receiveKeyEvent:(NSEvent *)theEvent;
- (void)receiveMouseEvent:(NSEvent *)theEvent;

- (void)setHeightOfMainView:(CGFloat)height;

- (void)startDraggingFromGridView;

@end
