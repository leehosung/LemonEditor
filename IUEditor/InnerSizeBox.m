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

@implementation InnerSizeBox{
    NSInteger width;
    SizeTextField *leftTF;
    SizeTextField *rightTF;
}

- (id)initWithFrame:(NSRect)frame width:(NSInteger)aWidth{
    self = [super initWithFrame:frame];
    if (self) {
        width = aWidth;
        [self setFillColor:[NSColor secondarySelectedControlColor]];
        [self setTitlePosition:NSNoTitle];
        [self setBoxType:NSBoxCustom];
        [self setBorderType:NSLineBorder];
        [self setBorderWidth:0.5];
        [self setBorderColor:[NSColor grayColor]];
        
        NSString *tfTitle = [NSString stringWithFormat:@"%ld", aWidth];
        
        rightTF = [[SizeTextField alloc] initWithFrame:NSMakeRect(aWidth-50, 4, 40, 11)];
        [rightTF setFont:[NSFont systemFontOfSize:9]];
        [rightTF setAlignment:NSRightTextAlignment];
        [rightTF setStringValue:tfTitle];
        [self addSubview:rightTF];
        
        //For center
        /*
        leftTF = [[SizeTextField alloc] initWithFrame:NSMakeRect(0, 4, 40, 11)];
        [leftTF setFont:[NSFont systemFontOfSize:9]];
        [leftTF setAlignment:NSLeftTextAlignment];
        [leftTF setStringValue:tfTitle];
        [self addSubview:leftTF];
         */
        
    }
    return self;
}

#pragma mark -
#pragma mark mouse

- (void)mouseDown:(NSEvent *)theEvent{
    if(theEvent.clickCount == 1){
        [self select];
    }
    
}

- (void)rightMouseDown:(NSEvent *)theEvent{
    
    if(theEvent.clickCount == 1){
        NSMenu *sizeBoxMenu = [[NSMenu alloc] initWithTitle:@"InnerSizeBox"];
        NSMenuItem *removeMenu = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Remove %ld",width] action:@selector(removeSelf) keyEquivalent:@""];
        [sizeBoxMenu addItem:removeMenu];
        
        [NSMenu popUpContextMenu:sizeBoxMenu withEvent:theEvent forView:self];
    }
    
}

- (void)removeSelf{
    [(SizeView *)self.boxDelegate removeFrame:width];
}

#pragma mark -
#pragma mark open

- (NSInteger)frameWidth{
    return width;
}


- (void)select{
    
    //send other sizeBox release
    if(self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(selectBox:)]){
        [(SizeView *)self.boxDelegate selectBox:self];
        
    }
}

- (void)setSmallerColor{
    [self setFillColor:[NSColor whiteColor]];
}

- (void)setLargerColor{
    [self setFillColor:[NSColor secondarySelectedControlColor]];
}

@end
