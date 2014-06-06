//
//  LMFileNaviCellView.h
//  IUEditor
//
//  Created by jd on 5/27/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUProject.h"
#import "IUController.h"

@interface LMFileNaviCellView : NSTableCellView <NSTextFieldDelegate>

- (void)startEditing;

@property (weak) IUProject *project;

@end
