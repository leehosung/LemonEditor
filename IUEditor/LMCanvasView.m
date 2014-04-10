//
//  LMCanvasView.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMCanvasView.h"
#import "LMCanvasVC.h"

@implementation LMCanvasView{
    BOOL isSelected, isDragged, isSelectDragged;
    NSPoint startDragPoint, middleDragPoint, endDragPoint;
    NSUInteger keyModifierFlags;
}


- (void)awakeFromNib{
    
    self.mainView = [[NSFlippedView alloc] init];
    self.webView = [[WebCanvasView alloc] init];
    self.gridView = [[GridView alloc] init];
    
    self.webView.delegate = self.delegate;
    self.gridView.delegate= self.delegate;
    self.sizeView.delegate = self.delegate;
    
    [self.mainScrollView setDocumentView:self.mainView];
    [self.mainView addSubviewFullFrame:self.webView];
    [self.mainView addSubviewFullFrame:self.gridView];
    
    [self.mainView setFrameOrigin:NSZeroPoint];
    [self.mainView setFrameSize:NSMakeSize(defaultFrameWidth, self.mainScrollView.frame.size.height)];
    
    [self.mainView addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
}

- (BOOL)isFlipped{
    return YES;
}

#pragma mark -
#pragma mark sizeView

- (void)frameDidChange:(NSDictionary *)change{
    JDDebugLog(@"mainView: point(%.1f, %.1f) size(%.1f, %.1f)",
               self.mainView.frame.origin.x,
               self.mainView.frame.origin.y,
               self.mainView.frame.size.width,
               self.mainView.frame.size.height);
    
    JDDebugLog(@"gridView: point(%.1f, %.1f) size(%.1f, %.1f)",
               self.gridView.frame.origin.x,
               self.gridView.frame.origin.y,
               self.gridView.frame.size.width,
               self.gridView.frame.size.height);

    JDDebugLog(@"webView: point(%.1f, %.1f) size(%.1f, %.1f)",
               self.webView.frame.origin.x,
               self.webView.frame.origin.y,
               self.webView.frame.size.width,
               self.webView.frame.size.height);
}


- (void)setWidthOfMainView:(CGFloat)width{
    [self.mainView setWidth:width];
    
}

- (void)setHeightOfMainView:(CGFloat)height{
//    [self.mainScrollView.contentView setHeight:height];
    [self.mainView setHeight:height];
    [self.webView resizePageContent];
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
    
    if( [((LMCanvasVC *)self.delegate) containsIU:IUID] == YES &&
        [((LMCanvasVC *)self.delegate) countOfSelectedIUs] == 1){
        return NO;
    }
    return YES;
}

-  (BOOL)pointInMainView:(NSPoint)point{
    if (NSPointInRect(point, self.bounds)){
        return YES;
    }
    return NO;
}

#pragma mark event

-(void)receiveKeyEvent:(NSEvent *)theEvent{
    NSResponder *currentResponder = [[self window] firstResponder];
    NSView *mainView = self.mainView;
    
    if([currentResponder isKindOfClass:[NSView class]]
       && [mainView hasSubview:(NSView *)currentResponder]){
        
        if(theEvent.type == NSKeyDown){
            unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
            
            
            if([[self webView] isEditable]== NO){
                //delete key
                if(key == NSDeleteCharacter){
                    [((LMCanvasVC *)self.delegate) removeSelectedIUs];
                }
                
            }
        }
    }
}


-(void)receiveMouseEvent:(NSEvent *)theEvent{
    
    
    NSPoint originalPoint = [theEvent locationInWindow];
    NSPoint convertedPoint = [self.mainView convertPoint:originalPoint fromView:nil];
    NSView *hitView = [self.gridView hitTest:convertedPoint];
    
    if([hitView isKindOfClass:[GridView class]] == NO){
        
        if( [self pointInMainView:convertedPoint]){
            
            if ( theEvent.type == NSLeftMouseDown){
                JDTraceLog( @"mouse down");
                NSString *currentIUID = [self.webView IDOfCurrentIU];
                
                if (theEvent.clickCount == 1
                    || theEvent.clickCount == 2){
                    
                    if( [self canRemoveIU:theEvent IUID:currentIUID] ){
                        [((LMCanvasVC *)self.delegate) deselectedAllIUs];
                        
                    }
                    
                    if([self canAddIU:currentIUID]){
                        [((LMCanvasVC *)self.delegate) addSelectedIU:currentIUID];
                        //다른 iu를 선택하는 순간 editing mode out
                        [[self webView] setEditable:NO];
                    }
                    
                    if([self.webView isDOMTextAtPoint:convertedPoint] == NO
                       && currentIUID){
                        isSelected = YES;
                    }

                    //change editable mode
                    if(theEvent.clickCount ==2){
                        [[self webView] setEditable:YES];
                        [[self webView] changeDOMRange:convertedPoint];
                    }
                }
                startDragPoint = convertedPoint;
                middleDragPoint = startDragPoint;
            }
            else if (theEvent.type == NSLeftMouseDragged ){
                JDTraceLog( @"mouse dragged");
                endDragPoint = convertedPoint;
                
                if([theEvent modifierFlags] & NSCommandKeyMask ){
                    [self selectWithDrawRect];
                }
                if(isSelected){
                    [self moveIUByDragging];
                }
              
                middleDragPoint = endDragPoint;
            }
            
        }
        
        
        if ( theEvent.type == NSLeftMouseUp ){
            JDTraceLog( @"NSLeftMouseUp");
            [self clearMouseMovement];
            
        }
    }
    else {
        JDTraceLog( @"gridview select");
    }

    
    if(isSelectDragged){
        [[NSCursor crosshairCursor] push];
    }
}


#pragma mark -
#pragma mark handle mouse event

- (void)moveIUByDragging{
    isDragged = YES;
    NSPoint totalPoint = NSMakePoint(endDragPoint.x-startDragPoint.x, endDragPoint.y-startDragPoint.y);
    NSPoint diffPoint = NSMakePoint(endDragPoint.x - middleDragPoint.x, endDragPoint.y - middleDragPoint.y);
    [((LMCanvasVC *)self.delegate) moveIUToDiffPoint:diffPoint totalDiffPoint:totalPoint];
    
}

- (void)selectWithDrawRect{
    isSelectDragged = YES;
    isSelected = NO;
    
    NSSize size = NSMakeSize(endDragPoint.x-startDragPoint.x, endDragPoint.y-startDragPoint.y);
    NSRect selectFrame = NSMakeRect(startDragPoint.x, startDragPoint.y, size.width, size.height);
    
    [self.gridView drawSelectionLayer:selectFrame];
    [((LMCanvasVC *)self.delegate) selectIUInRect:selectFrame];
}

- (void)clearMouseMovement{
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

@end
