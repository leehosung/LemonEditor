//
//  LMCanvasView.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMCanvasView.h"
#import "IUDefinition.h"
#import "LMCanvasVC.h"

@implementation LMCanvasView


- (void)awakeFromNib{
    
    self.webView = [[WebCanvasView alloc] init];
    self.gridView = [[GridView alloc] init];
    
    self.webView.delegate = self.delegate;
    self.gridView.delegate= self.delegate;
    
    [self.mainView addSubviewFullFrame:self.webView];
    [self.mainView addSubviewFullFrame:self.gridView];
    
    [self setWidthOfMainView:defaultFrameWidth];
    
}

#pragma mark -
#pragma mark sizeView


- (void)setWidthOfMainView:(CGFloat)width{
    [self.mainView setWidth:width];
    CGFloat x = ([self frame].size.width - width)/2;
    if(x < 0){
        x = 0;
    }
    [self.mainView setX:x];
}

#pragma mark -
#pragma mark mouseEvent


- (BOOL)canAddIU:(NSString *)IUID{
    if(IUID != nil){
        if( [((LMCanvasVC *)self.delegate) containsIU:IUID] == NO ){
            return YES;
        }
    }
    return NO;
}

- (BOOL)canRemoveIU:(NSEvent *)theEvent IUID:(NSString *)IUID{
    
    if( ( [theEvent modifierFlags] & NSCommandKeyMask )){
        return NO;
    }
    
    if( [((LMCanvasVC *)self.delegate) containsIU:IUID] == YES ){
        return NO;
    }
    return YES;
}

-  (BOOL)pointInMainView:(NSPoint)point{
    if (NSPointInRect(point, self.mainView.bounds)){
        return YES;
    }
    return NO;
}

//it's from CanvasWindow(not a NSView)
-(void)receiveEvent:(NSEvent *)theEvent{
    
    NSPoint originalPoint = [theEvent locationInWindow];
    NSPoint convertedPoint = [self.mainView convertPoint:originalPoint fromView:nil];
    NSView *hitView = [self.gridView hitTest:convertedPoint];
    
    if([hitView isKindOfClass:[GridView class]] == NO){
        
        if( [self pointInMainView:convertedPoint]){
            
            if ( theEvent.type == NSLeftMouseDown){
                IULog(@"mouse down");
                NSString *currentIUID = [self.webView IDOfCurrentIU];
                
                if (theEvent.clickCount == 1){
                    
                    
                    if( [self canRemoveIU:theEvent IUID:currentIUID] ){
                        [((LMCanvasVC *)self.delegate) removeSelectedAllIUs];
                        
                    }
                    
                    if([self canAddIU:currentIUID]){
                        [((LMCanvasVC *)self.delegate) addSelectedIU:currentIUID];
                    }
                    
                    if([self.webView isDOMTextAtPoint:convertedPoint] == NO){
                        isSelected = YES;
                    }
                    startDragPoint = convertedPoint;
                    middleDragPoint = startDragPoint;
                }
            }
            else if (theEvent.type == NSLeftMouseDragged ){
                IULog(@"mouse dragged");
                endDragPoint = convertedPoint;
                
                //draw select rect
                if([theEvent modifierFlags] & NSCommandKeyMask ){
                    isSelectDragged = YES;
                    isSelected = NO;
                    
                    NSSize size = NSMakeSize(endDragPoint.x-startDragPoint.x, endDragPoint.y-startDragPoint.y);
                    NSRect selectFrame = NSMakeRect(startDragPoint.x, startDragPoint.y, size.width, size.height);
                    
                    [self.gridView drawSelectionLayer:selectFrame];
                    [((LMCanvasVC *)self.delegate) selectIUInRect:selectFrame];
                    
                }
                if(isSelected){
                    isDragged = YES;
                    NSPoint diffPoint = NSMakePoint(endDragPoint.x - middleDragPoint.x, endDragPoint.y - middleDragPoint.y);
                    [((LMCanvasVC *)self.delegate) moveDiffPoint:diffPoint];
                }
                
                
                middleDragPoint = endDragPoint;
            }
            
            //END : mainView handling
        }
        
        
        if ( theEvent.type == NSLeftMouseUp ){
            //        IULog(@"NSLeftMouseUp");
            
            [self.gridView clearGuideLine];
            
            if(isSelected){
                isSelected = NO;
            }
            if(isDragged){
                isDragged = NO;
            }
            if(isSelectDragged){
                isSelectDragged = NO;
                [NSCursor pop];
                [self.gridView resetSelectionLayer];
            }
        }
    }
    else {
        IULog(@"gridview select");
    }

    
    if(isSelectDragged){
        [[NSCursor crosshairCursor] push];
    }
}

@end
