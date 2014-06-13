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
//@property (weak) IBOutlet NSTextField *fontSizeB;
//@property (weak) IBOutlet NSStepper *fontSizeStepper;
@property (weak) IBOutlet NSComboBox *fontSizeComboBox;
@property (weak) IBOutlet NSColorWell *fontColorWell;

@property (weak) IBOutlet NSSegmentedControl *fontStyleB;
@property (weak) IBOutlet NSSegmentedControl *textAlignB;
@property (weak) IBOutlet NSComboBox *lineHeightB;

@property LMFontController *fontController;
@property (strong) IBOutlet NSDictionaryController *fontListDC;

@property NSArray *fontDefaultSizes;

@end

@implementation LMPropertyTextVC{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fontDefaultSizes = @[@(6), @(8), @(9), @(10), @(11), @(12),
                                  @(14), @(18), @(21), @(24), @(30), @(36), @(48), @(60), @(72)];
        
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

- (void)dealloc{
    //release 시점 확인용
    assert(0);
}
- (void)unbindTextSpecificProperty{
    if([_fontB infoForBinding:NSValueBinding]){
        [_fontB unbind:NSValueBinding];
    }
    if([_fontSizeComboBox infoForBinding:NSValueBinding]){
        [_fontSizeComboBox unbind:NSValueBinding];
    }
    /*
    if([_fontSizeB infoForBinding:NSValueBinding]){
        [_fontSizeB unbind:NSValueBinding];
    }
    if([_fontSizeStepper infoForBinding:NSValueBinding]){
        [_fontSizeStepper unbind:NSValueBinding];
    }
     */
    if([_fontColorWell infoForBinding:NSValueBinding]){
        [_fontColorWell unbind:NSValueBinding];
    }
}

- (BOOL)isSelectedObjectText{
    BOOL isText = YES;
    
    for(IUBox *box in _controller.selectedObjects){
        if([box isKindOfClass:[IUText class]] == NO){
            isText = NO;
            break;
        }
    }
    
    return isText;
    
}

- (void)selectionContextDidChange:(NSDictionary *)change{
    
    [self unbindTextSpecificProperty];
    
    if([self isSelectedObjectText]){
        [_fontStyleB setEnabled:YES];

        [_fontB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"fontName"] options:IUBindingDictNotRaisesApplicable];
        [_fontSizeComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"fontSize"] options:IUBindingDictNotRaisesApplicable];
        [_fontColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToTextCSSProperty:@"fontColor"] options:IUBindingDictNotRaisesApplicable];
        
        
        if([[_controller selectedObjects] count] ==1 ){
            BOOL weight = ((IUText *)_controller.selection).textController.bold;
            [_fontStyleB setSelected:weight forSegment:0];
            
            BOOL italic = ((IUText *)_controller.selection).textController.italic;
            [_fontStyleB setSelected:italic forSegment:1];
            
            BOOL underline = ((IUText *)_controller.selection).textController.underline;
            [_fontStyleB setSelected:underline forSegment:2];
        }

    }
    else{
        //not text - text field / text view
        [_fontStyleB setEnabled:NO];

        [_fontB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontName] options:IUBindingDictNotRaisesApplicable];
        [_fontSizeComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontSize] options:IUBindingDictNotRaisesApplicable];
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
- (IBAction)clickLineHeightComboBox:(id)sender {
    NSString *lineHeightStr = [sender stringValue];
    if([_controller.selection respondsToSelector:@selector(setLineHeightAuto:)]){
        
        if([lineHeightStr isEqualToString:@"Auto"]){
            [_controller.selection setLineHeightAuto:YES];
        }
        else{
            [_controller.selection setLineHeightAuto:NO];
        }
    }
}

#pragma mark -
#pragma mark combobox dataSource

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox{
    return _fontDefaultSizes.count;
}
- (id)comboBox:(NSComboBox *)categoryCombo objectValueForItemAtIndex:(NSInteger)row {
    return [_fontDefaultSizes objectAtIndex:row];
}

@end
