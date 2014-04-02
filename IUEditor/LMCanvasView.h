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

@interface LMCanvasView : NSSplitView {
    BOOL isSelected, isDragged, isSelectDragged;
    NSPoint startDragPoint, middleDragPoint, endDragPoint;
}

@property (weak) IBOutlet NSView *mainView;

@property SizeView *sizeView;
@property WebCanvasView *webView;
@property GridView *gridView;

-(void)sendEvent:(NSEvent *)theEvent;
- (void)setWidthOfMainView:(CGFloat)width;

@end
