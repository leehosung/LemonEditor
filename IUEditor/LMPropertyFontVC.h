//
//  LMPropertyFontVC.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 11..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"

@interface LMPropertyFontVC : NSViewController

@property (nonatomic) _binding_ IUController *controller;
@property (strong) IBOutlet NSFontManager *fontManager;

@property (weak) IBOutlet NSComboBox *fontName;
@property (weak) IBOutlet NSComboBox *fontSize;
@property (weak) IBOutlet NSColorWell *fontColor;
@property (weak) IBOutlet NSSegmentedControl *fontTraits;
@property (weak) IBOutlet NSSegmentedControl *fontAlignment;
@property (weak) IBOutlet NSComboBox *fontLineHeight;

- (IBAction)clickFontNameBtn:(id)sender;
- (IBAction)clickFontSizeBtn:(id)sender;

- (IBAction)clickFontColor:(id)sender;
- (IBAction)clickFontTraitsControl:(id)sender;
- (IBAction)clickFontAlignControl:(id)sender;

- (IBAction)clickLineHeight:(id)sender;
- (IBAction)clickTestBtn:(id)sender;
@end
