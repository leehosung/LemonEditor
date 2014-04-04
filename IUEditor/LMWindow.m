//
//  CanvasWindow.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 24..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "LMWindow.h"
#import "LMWC.h"
#import "JDUIUtil.h"
#import "JDLogUtil.h"
#import "IUDefinition.h"

@implementation LMWindow


#pragma mark -
#pragma mark mouse

- (BOOL)isMouseEvent:(NSEvent *)theEvent{
    if(theEvent.type == NSLeftMouseDown ||
       theEvent.type == NSLeftMouseUp   ||
       theEvent.type ==  NSRightMouseDown ||
       theEvent.type == NSRightMouseUp ||
       theEvent.type == NSMouseMoved ||
       theEvent.type == NSLeftMouseDragged ||
       theEvent.type == NSRightMouseDragged ||
       theEvent.type == NSMouseEntered ||
       theEvent.type == NSMouseExited
       ){
        return YES;
    }
    return NO;
}

- (BOOL)isKeyEvent:(NSEvent *)theEvent{
    if(theEvent.type == NSKeyDown ||
       theEvent.type == NSKeyUp ||
       theEvent.type == NSFlagsChanged
       ){
        return YES;
    }
    return NO;
}

-(void)sendEvent:(NSEvent *)theEvent{
    
    [super sendEvent:theEvent];
    if([self isMouseEvent:theEvent]){
        [self.canvasView receiveMouseEvent:theEvent];
    }
}

@end
