//
//  LMFileTabVC.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUSheetController.h"
#import "IUSheetGroup.h"

@interface LMTabBox : NSBox

@property IBOutlet id delegate;

@end

@interface LMFileTabItemVC : NSViewController

@property id delegate;
@property (weak) IBOutlet NSBox *fileBox;
@property (weak) IBOutlet NSButton *fileNameBtn;
@property  IUSheet *sheet;

- (void)setDeselectColor;
- (void)setSelectColor;
@end
