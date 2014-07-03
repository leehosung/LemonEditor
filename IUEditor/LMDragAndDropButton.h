//
//  LMDragAndDropImageV.h
//  IUEditor
//
//  Created by jd on 7/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LMDragAndDropButton;

@protocol LMDragAndDropImageVDelegate <NSObject>
- (void)draggingDropedForDragAndDropImageV:(LMDragAndDropButton*)v item:(id)item;
@end

@interface LMDragAndDropButton : NSButton

- (void)registerForDraggedType:(NSString *)type;

@property IBOutlet id < LMDragAndDropImageVDelegate > delegate;

@end
