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

@interface SizeView : NSView

@property id delegate;

//addFrameSize
@property (weak) IBOutlet NSButton *addBtn;
@property (weak) IBOutlet NSPopover *addFramePopover;
@property (weak) IBOutlet NSTextField *addFrameSizeField;

- (IBAction)addSizeBtnClick:(id)sender;
- (IBAction)addSizeOKBtn:(id)sender;

- (NSInteger)nextSmallSize:(NSInteger)size;

- (void)selectBox:(InnerSizeBox *)selectBox;

- (void)addFrame:(NSInteger)width;
- (void)removeFrame:(NSInteger)width;

//scroll by canvasV
- (void)moveSizeView:(NSPoint)point withWidth:(CGFloat)width;

@property NSMutableArray *sizeArray;
- (NSArray *)sortedArray;

@end
