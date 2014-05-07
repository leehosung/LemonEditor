//
//  GridView.h
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 21..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PointLayer.h"
#import "GuideLineLayer.h"

@interface GridView : NSView{
    CALayer *selectionLayer, *ghostLayer;
    CALayer *borderManagerLayer;
    CALayer *textManageLayer, *pointManagerLayer;
    GuideLineLayer *guideLayer;
    
    //for dragging - change width, height ofIU
    BOOL isClicked, isDragged;
    NSPoint startPoint, middlePoint;
    IUPointLayerPosition selectedPointType;
    
    //for managing cursor
    NSMutableDictionary *cursorDict;
}

@property id delegate;

- (void)addRedPointLayer:(NSString *)iuID withFrame:(NSRect)frame;
- (void)removeAllRedPointLayer;

- (void)addTextPointLayer:(NSString *)iuID withFrame:(NSRect)frame;
- (void)removeAllTextPointLayer;

- (void)drawSelectionLayer:(NSRect)frame;
- (void)resetSelectionLayer;

- (void)updateLayerRect:(NSMutableDictionary *)frameDict;

- (void)setBorder:(BOOL)border;
- (void)setGhost:(BOOL)ghost;
- (void)setGhostImage:(NSImage *)image;
- (void)setGhostPosition:(NSPoint)position;
- (void)setGhostOpacity:(CGFloat)opacity;

- (void)drawGuideLine:(NSArray *)array;
- (void)clearGuideLine;

@end
