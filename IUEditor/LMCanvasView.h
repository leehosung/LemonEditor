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

@interface LMCanvasView : NSSplitView

@property (weak) IBOutlet NSFlippedView *mainView;
@property WebCanvasView *webView;
@property GridView *gridView;

@property (weak) IBOutlet SizeView *sizeView;

- (void)receiveMouseEvent:(NSEvent *)theEvent;
- (void)setWidthOfMainView:(CGFloat)width;

@end
