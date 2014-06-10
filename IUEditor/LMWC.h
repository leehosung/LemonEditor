//
//  LMWC.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUSheetController.h"
#import "IUSheetGroup.h"
#import "WebCanvasView.h"
#import "IUFrameDictionary.h"
#import "IUController.h"

@class LMWindow;

@interface LMWC : NSWindowController <NSWindowDelegate>

@property (nonatomic) _binding_ IUSheet *selectedNode;
@property (nonatomic, weak) _binding_ IUController   *IUController;
@property (nonatomic, weak) _binding_ IUSheetController   *documentController;
@property _binding_ NSRange selectedTextRange;

@property (nonatomic) IUBox *pastedNewIU;

- (void)loadProject:(NSString*)path;
- (void)selectFirstDocument;

- (void)reloadCurrentDocument;

- (void)addMQSize:(NSInteger)size;
- (void)removeMQSize:(NSInteger)size;

@end