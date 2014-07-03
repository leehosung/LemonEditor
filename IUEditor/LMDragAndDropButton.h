//
//  LMDragAndDropImageV.h
//  IUEditor
//
//  Created by jd on 7/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LMDragAndDropImageV;

@protocol LMDragAndDropImageVDelegate <NSObject>
- (void)draggingDropedForDragAndDropImageV:(LMDragAndDropImageV*)v item:(id)item;
@end

@interface LMDragAndDropImageV : NSImageView

- (void)registerForDraggedType:(NSString *)type;

@property NSImage *originalImage;
@property NSImage *highlightedImage;
@property IBOutlet id < LMDragAndDropImageVDelegate > delegate;

@end
