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
    SizeTextField *sizeTextField;
}

- (void)selectBox:(InnerSizeBox *)selectBox;
- (NSInteger)selectedFrameWidth;

- (id)addFrame:(NSInteger)width;
- (void)removeFrame:(NSInteger)width;

@end
