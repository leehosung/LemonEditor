//
//  LMCollectionItemView.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMCollectionItemView.h"

@implementation LMCollectionItemView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSView *)hitTest:(NSPoint)aPoint{
    // don't allow any mouse clicks for subviews in this view
    if(NSPointInRect(aPoint,[self convertRect:[self bounds] toView:[self superview]])) {
        return self;
    } else {
        return nil;
    }
}

- (void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
    // check for click count above one, which we assume means it's a double click
    if([theEvent clickCount] > 1) {
        if(_delegate && [_delegate respondsToSelector:@selector(doubleClick:)]) {
            [_delegate performSelector:@selector(doubleClick:) withObject:self];
        }
    }
   
}

- (void)rightMouseDown:(NSEvent *)theEvent{
    [super rightMouseDown:theEvent];
    // rightMouseDown
    if([theEvent type] == NSRightMouseDown) {
        if(_delegate && [_delegate respondsToSelector:@selector(rightMouseDown:theEvent:)]) {
            [_delegate performSelector:@selector(rightMouseDown:theEvent:) withObject:self withObject:theEvent];
        }
    }
}

@end
