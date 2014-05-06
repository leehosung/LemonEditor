//
//  LMPropertyTextVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyTextVC.h"
#import "IUCSS.h"
#import "IUBox.h"

@interface LMPropertyTextVC ()

@property (weak) IBOutlet NSComboBox *fontB;
@property (weak) IBOutlet NSTextField *fontSizeB;
@property (weak) IBOutlet NSStepper *fontSizeStepper;
@property (weak) IBOutlet NSColorWell *fontColorWell;

@property (weak) IBOutlet NSSegmentedControl *fontStyleB;
@property (weak) IBOutlet NSSegmentedControl *textAlignB;
@property (weak) IBOutlet NSComboBox *lineHeightB;

@end

@implementation LMPropertyTextVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)awakeFromNib{
    
    [_fontB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontName] options:IUBindingDictNotRaisesApplicable];
    [_fontB bind:NSContentBinding toObject:[NSFontManager sharedFontManager] withKeyPath:@"availableFontFamilies" options:IUBindingDictNotRaisesApplicable];
    [_fontSizeB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontSize] options:IUBindingDictNotRaisesApplicable];
    [_fontSizeStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontSize] options:IUBindingDictNotRaisesApplicable];
    [_fontColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontColor] options:IUBindingDictNotRaisesApplicable];
    [_lineHeightB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagLineHeight] options:IUBindingDictNotRaisesApplicable];
    [_textAlignB bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagTextAlign] options:IUBindingDictNotRaisesApplicable];
    
    [self addObserver:self forKeyPath:@"controller.selection"
              options:NSKeyValueObservingOptionInitial context:@"fontDeco"];
    
}

- (void)fontDecoContextDidChange:(NSDictionary *)change{
    if([_controller.selection isKindOfClass:[IUBox class]]){
        BOOL weight = [((IUBox *)_controller.selection).css.assembledTagDictionary[IUCSSTagFontWeight] boolValue];
        [_fontStyleB setSelected:weight forSegment:0];
        
        BOOL italic = [((IUBox *)_controller.selection).css.assembledTagDictionary[IUCSSTagFontStyle] boolValue];
        [_fontStyleB setSelected:italic forSegment:1];
        
        BOOL underline = [((IUBox *)_controller.selection).css.assembledTagDictionary[IUCSSTagTextDecoration] boolValue];
        [_fontStyleB setSelected:underline forSegment:2];
    }
}


- (IBAction)fontDecoBPressed:(id)sender {
    
    BOOL value;
    value = [sender isSelectedForSegment:0];
    [self setValue:@(value) forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontWeight]];
    
    value = [sender isSelectedForSegment:1];
    [self setValue:@(value) forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontStyle]];
    
    value = [sender isSelectedForSegment:2];
    [self setValue:@(value) forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagTextDecoration]];
    
}

@end
