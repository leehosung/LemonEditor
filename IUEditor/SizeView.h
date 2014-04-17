//
//  SizeView.h
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 4. 1..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InnerSizeBox.h"
@interface SizeTextField : NSTextField

@end

@interface SizeView : NSView{
    NSMutableArray *sizeArray;
    NSView *boxManageView;
    NSUInteger selectIndex;
    NSUInteger selectedWidth;
    SizeTextField *sizeTextField;
    NSPopover *framePopover;
}

@property id delegate;

//addFrameSize
@property (weak) IBOutlet NSButton *addBtn;
@property (weak) IBOutlet NSPopover *addFramePopover;
@property (weak) IBOutlet NSTextField *addFrameSizeField;

- (IBAction)addSizeBtnClick:(id)sender;
- (IBAction)addSizeOKBtn:(id)sender;

- (void)moveSizeView:(NSPoint)point withWidth:(CGFloat)width;

- (NSInteger)nextSmallSize:(NSInteger)size;

- (void)selectBox:(InnerSizeBox *)selectBox;

- (id)addFrame:(NSInteger)width;
- (void)removeFrame:(NSInteger)width;

@end
