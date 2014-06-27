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
#import "LMCloseWC.h"


@implementation LMWindow{
    LMCloseWC *closeWC;
}


#pragma mark -
#pragma mark mouse

- (void)awakeFromNib{
     closeWC = [[LMCloseWC alloc] initWithWindowNibName:[LMCloseWC class].className];

}

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
       theEvent.type == NSKeyUp
       ){
        return YES;
    }
    return NO;
}

-(void)sendEvent:(NSEvent *)theEvent{
    
    BOOL callSuper = YES;
    
    if([self isMouseEvent:theEvent]){
        [self.canvasView receiveMouseEvent:theEvent];
    }
    if([self isKeyEvent:theEvent]){
        callSuper = [self.canvasView receiveKeyEvent:theEvent];
    }
    
    if(callSuper){
        [super sendEvent:theEvent];
    }

}


#pragma mark - close

- (void)performClose:(id)sender{
    
    [closeWC setProjectName:[(LMWC *)[self windowController] projectName]];
    [self setAlphaValue:0.9];
    [self setIgnoresMouseEvents:YES];
    
    [self beginCriticalSheet:closeWC.window completionHandler:^(NSModalResponse returnCode) {
        switch (returnCode) {
                [closeWC.window orderOut:nil];
            case NSModalResponseOK:
                [self close];
                break;
            case NSModalResponseCancel:
                [self setIgnoresMouseEvents:NO];
                [self setAlphaValue:1.0];
            default:
                break;
        }
    }];
        
}



@end
