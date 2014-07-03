//
//  LMCollectionItemView.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 7. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol LMCollectionDelegate <NSObject>

- (void)doubleClick:(id)sender;
- (void)rightMouseDown:(id)sender theEvent:(NSEvent *)theEvent;

@end

@interface LMCollectionItemView : NSView

@property IBOutlet id<LMCollectionDelegate> delegate;

@end
