//
//  SizeBox.h
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 4. 1..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InnerSizeBox : NSBox

@property id boxDelegate;

- (CGFloat)frameSize;
- (void)select;
- (void)deselect;


@end
