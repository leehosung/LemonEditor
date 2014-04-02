//
//  SizeBox.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 4. 1..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "InnerSizeBox.h"
#import "JDUIUtil.h"
#import "SizeView.h"

@implementation InnerSizeBox

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFillColor:[NSColor whiteColor]];
        [self setTitlePosition:NSNoTitle];
        [self setBoxType:NSBoxCustom];
        [self setBorderType:NSLineBorder];
        [self setBorderWidth:2.0];
        [self setBorderColor:[NSColor blackColor]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark -
#pragma mark mouse

- (void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
    if(theEvent.clickCount == 1){
        [self select];
    }
}

#pragma mark -
#pragma mark open

- (CGFloat)frameSize{
    return self.frame.size.width;
}

- (void)deselect{
    [self setBorderColor:[NSColor blackColor]];
    [self setFillColor:[NSColor whiteColor]];
}

- (void)select{
    [self setBorderColor:[NSColor selectedMenuItemColor]];
    [self setFillColor:[NSColor selectedControlColor]];
    
    //send other sizeBox release
    if(self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(selectBox:)]){
        [(SizeView *)self.boxDelegate selectBox:self];
        
    }
}


@end
