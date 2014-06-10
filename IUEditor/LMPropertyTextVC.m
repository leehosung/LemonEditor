//
//  LMPropertyTextVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyTextVC.h"
#import "IUCSS.h"
#import "IUText.h"
#import "LMFontController.h"


@interface LMPropertyTextVC ()

@property (weak) IBOutlet NSComboBox *fontB;
@property (weak) IBOutlet NSTextField *fontSizeB;
@property (weak) IBOutlet NSStepper *fontSizeStepper;
@property (weak) IBOutlet NSColorWell *fontColorWell;

@property (weak) IBOutlet NSSegmentedControl *fontStyleB;
@property (weak) IBOutlet NSSegmentedControl *textAlignB;
@property (weak) IBOutlet NSComboBox *lineHeightB;

@property LMFontController *fontController;
@property (strong) IBOutlet NSDictionaryController *fontListDC;

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
    
    [_lineHeightB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagLineHeight] options:IUBindingDictNotRaisesApplicable];
    [_textAlignB bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagTextAlign] options:IUBindingDictNotRaisesApplicable];
    
    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:0 context:@"selection"];
    
    _fontController = [LMFontController sharedFontController];
    [_fontListDC bind:NSContentDictionaryBinding toObject:_fontController withKeyPath:@"fontDict" options:nil];
    [_fontB bind:NSContentBinding toObject:_fontListDC withKeyPath:@"arrangedObjects.key" options:IUBindingDictNotRaisesApplicable];

    
}

- (void)unbindTextSpecificProperty{
    if([_fontB infoForBinding:NSValueBinding]){
        [_fontB unbind:NSValueBinding];
    }
    if([_fontSizeB infoForBinding:NSValueBinding]){
        [_fontSizeB unbind:NSValueBinding];
    }
    if([_fontSizeStepper infoForBinding:NSValueBinding]){
        [_fontSizeStepper unbind:NSValueBinding];
    }
    if([_fontColorWell infoForBinding:NSValueBinding]){
        [_fontColorWell unbind:NSValueBinding];
    }
}

- (void)selectionContextDidChange:(NSDictionary *)change{
    
    [self unbindTextSpecificProperty];
    
    if( [_controller.selection isKindOfClass:[IUText class]]){
        [_fontStyleB setEnabled:YES];

        [_fontB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"fontName"] options:IUBindingDictNotRaisesApplicable];
        [_fontSizeB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"fontSize"] options:IUBindingDictNotRaisesApplicable];
        [_fontSizeStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"fontSize"] options:IUBindingDictNotRaisesApplicable];
        [_fontColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"fontColor"] options:IUBindingDictNotRaisesApplicable];
        
        
        BOOL weight = ((IUText *)_controller.selection).textController.bold;
        [_fontStyleB setSelected:weight forSegment:0];
        
        BOOL italic = ((IUText *)_controller.selection).textController.italic;
        [_fontStyleB setSelected:italic forSegment:1];
        
        BOOL underline = ((IUText *)_controller.selection).textController.underline;
        [_fontStyleB setSelected:underline forSegment:2];

    }
    else{
        //not text - text field / text view
        [_fontStyleB setEnabled:NO];

        [_fontB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontName] options:IUBindingDictNotRaisesApplicable];
        [_fontSizeB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontSize] options:IUBindingDictNotRaisesApplicable];
        [_fontSizeStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontSize] options:IUBindingDictNotRaisesApplicable];
        [_fontColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontColor] options:IUBindingDictNotRaisesApplicable];
        
    }
}


- (IBAction)fontDecoBPressed:(id)sender {
    
    BOOL value;
    value = [sender isSelectedForSegment:0];
    [self setValue:@(value) forKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"bold"]];
    
    value = [sender isSelectedForSegment:1];
    [self setValue:@(value) forKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"italic"]];
    
    value = [sender isSelectedForSegment:2];
    [self setValue:@(value) forKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"underline"]];
    
}

@end
