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
    NSBox *selectedBox;
    SizeTextField *leftTF;
    SizeTextField *rightTF;
    SizeImageView *imageView;
}

- (id)initWithFrame:(NSRect)frame width:(NSInteger)aWidth{
    self = [super initWithFrame:frame];
    if (self) {
        width = aWidth;
        [self setFillColor:[NSColor secondarySelectedControlColor]];
        [self setTitlePosition:NSNoTitle];
        [self setBoxType:NSBoxCustom];
        [self setBorderType:NSLineBorder];
        [self setBorderColor:[NSColor grayColor]];
        [self setContentViewMargins:NSZeroSize];
        
        NSString *tfTitle = [NSString stringWithFormat:@"%ld", aWidth];
        
        rightTF = [[SizeTextField alloc] initWithFrame:NSMakeRect(aWidth-62, 8, 40, 11)];
        [rightTF setFont:[NSFont systemFontOfSize:9]];
        [rightTF setAlignment:NSRightTextAlignment];
        [rightTF setStringValue:tfTitle];
        [self addSubview:rightTF];
        
        imageView = [[SizeImageView alloc] initWithFrame:NSMakeRect(aWidth-20, 6, 15, 15)];
        if(aWidth < 650){
            [imageView setImage:[NSImage imageNamed:@"width_mobile"]];
        }
        else if(aWidth < 770){
            //imageView setImage:[NSImage imageNamed:@""];
        }
        else{
            [imageView setImage:[NSImage imageNamed:@"width_pc"]];
        }
        [self addSubview:imageView];

        //For center
        /*
        leftTF = [[SizeTextField alloc] initWithFrame:NSMakeRect(0, 4, 40, 11)];
        [leftTF setFont:[NSFont systemFontOfSize:9]];
        [leftTF setAlignment:NSLeftTextAlignment];
        [leftTF setStringValue:tfTitle];
        [self addSubview:leftTF];
         */
        
        selectedBox = [[NSBox alloc] initWithFrame:NSMakeRect(0, 0, self.frameWidth, 3.0)];
        [selectedBox setTitlePosition:NSNoTitle];
        [selectedBox setBoxType:NSBoxCustom];
        [selectedBox setBorderType:NSNoBorder];
        [selectedBox setFillColor:[NSColor rgbColorRed:50 green:150 blue:220 alpha:1]];
        
        [self addSubviewFullFrameAtTop:selectedBox height:3.0];

        
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
    [selectedBox setFillColor:[NSColor rgbColorRed:50 green:150 blue:220 alpha:1]];
}

- (void)setLargerColor{
    [self setFillColor:[NSColor secondarySelectedControlColor]];
    [selectedBox setFillColor:[NSColor clearColor]];
}

@end
