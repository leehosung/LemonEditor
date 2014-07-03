//
//  LMDragAndDropImageV.m
//  IUEditor
//
//  Created by jd on 7/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMDragAndDropButton.h"

@implementation LMDragAndDropButton{
    NSString *draggedType;
}

- (void)registerForDraggedType:(NSString *)type{
    [super registerForDraggedTypes:@[type]];
    draggedType = type;
}


- (id)initWithFrame:(NSRect)frame
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

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSLog(@"draggingEntered");
    [self setState:YES];
    return NSDragOperationEvery;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender{
    [self setState:NO];
    return;
}


- (void)draggingEnded:(id<NSDraggingInfo>)sender{
    NSPasteboard *pBoard = [sender draggingPasteboard];
    id item = [pBoard stringForType:draggedType];
    [self.delegate draggingDropedForDragAndDropImageV:self item:item];
    [self setState:NO];
    return;
}


@end
