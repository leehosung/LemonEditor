//
//  LMPropertyTextVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyFontVC.h"
#import "IUCSS.h"
#import "IUText.h"
#import "LMFontController.h"
#import "PGTextField.h"
#import "PGTextView.h"

@interface LMPropertyFontVC ()

@property (weak) IBOutlet NSComboBox *fontB;
@property (weak) IBOutlet NSComboBox *fontSizeComboBox;
@property (weak) IBOutlet NSColorWell *fontColorWell;

@property (weak) IBOutlet NSSegmentedControl *fontStyleB;
@property (weak) IBOutlet NSSegmentedControl *textAlignB;
@property (weak) IBOutlet NSComboBox *lineHeightB;

@property LMFontController *fontController;
@property (strong) IBOutlet NSDictionaryController *fontListDC;

@property NSArray *fontDefaultSizes;
@end

@implementation LMPropertyFontVC{
    NSString *currentFontName;
    NSUInteger currentFontSize;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentFontName = @"Arial";
        currentFontSize = 12;
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
    
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
    [_fontColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontColor] options:IUBindingDictNotRaisesApplicable];
#endif 
    
    
    
}

- (void)dealloc{
    //release 시점 확인용
    assert(0);
}


- (BOOL)isSelectedObjectText{
    BOOL isText = YES;
    
    
    for(IUBox *box in _controller.selectedObjects){
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
        if([box isKindOfClass:[IUText class]] == NO){
            isText = NO;
            break;
        }
#else
        if([box isMemberOfClass:[IUBox class]] == NO){
            isText = NO;
            break;
        }
#endif
        
    }
    return isText;
}

- (BOOL)isSelectedObjectFontType{
    BOOL isTextType = YES;
    
    
    for(IUBox *box in _controller.selectedObjects){
        if([box isMemberOfClass:[IUBox class]] == NO &&
           [box isKindOfClass:[PGTextField class]] == NO &&
           [box isKindOfClass:[PGTextView class]] == NO){
            isTextType = NO;
            break;
        }
        
    }
    return isTextType;
}

#if CURRENT_TEXT_VERSION > TEXT_SELECTION_VERSION

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

#else
- (void)selectionContextDidChange:(NSDictionary *)change{
    
    if([self isSelectedObjectFontType]){
        
        if([self isSelectedObjectText]){
            [_fontStyleB setEnabled:YES];
            if([[_controller selectedObjects] count] ==1 ){
                BOOL weight = [[_controller keyPathFromControllerToCSSTag:IUCSSTagFontWeight] boolValue];
                [_fontStyleB setSelected:weight forSegment:0];
                
                BOOL italic = [[_controller keyPathFromControllerToCSSTag:IUCSSTagFontStyle] boolValue];
                [_fontStyleB setSelected:italic forSegment:1];
                
                BOOL underline = [[_controller keyPathFromControllerToCSSTag:IUCSSTagTextDecoration] boolValue];
                [_fontStyleB setSelected:underline forSegment:2];
            }
        }
        else{
            [_fontStyleB setEnabled:NO];
        }
        
        
        
        //set font name
        NSString *iuFontName = [self valueForTag:IUCSSTagFontName];
        if(iuFontName == nil){
            iuFontName = currentFontName;
            [self setValue:currentFontName forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontName]];
        }
        if(iuFontName == NSMultipleValuesMarker){
            [_fontB setStringValue:currentFontName];
        }
        else{
            [_fontB setStringValue:iuFontName];
        }
        
        
        //set Font size
        NSUInteger iuFontSize;
        if([self valueForTag:IUCSSTagFontSize] == nil){
            iuFontSize = currentFontSize;
            [self setValue:@(currentFontSize) forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontSize]];
        }
        
        if([self valueForTag:IUCSSTagFontSize] == NSMultipleValuesMarker){
            [_fontSizeComboBox setStringValue:[NSString stringWithFormat:@"%ld", currentFontSize]];
            
        }
        else{
            iuFontSize = [[self valueForTag:IUCSSTagFontSize] integerValue];
            [_fontSizeComboBox setStringValue:[NSString stringWithFormat:@"%ld", iuFontSize]];
        }
        
        //enable font type box
        [_fontB setEnabled:YES];
        [_fontSizeComboBox setEnabled:YES];
        [_fontSizeComboBox setEditable:YES];
        [_fontColorWell setEnabled:YES];
        [_lineHeightB setEnabled:YES];
        [_lineHeightB setEditable:YES];
        [_textAlignB setEnabled:YES];

    }
    else{
        //disable font type box
        [_fontB setEnabled:NO];
        [_fontSizeComboBox setEnabled:NO];
        [_fontSizeComboBox setEditable:NO];
        [_fontColorWell setEnabled:NO];
        [_lineHeightB setEnabled:NO];
        [_lineHeightB setEditable:NO];
        [_textAlignB setEnabled:NO];
        [_fontStyleB setEnabled:NO];
    }
    
}

- (id)valueForTag:(IUCSSTag)tag
{
    id value = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:tag]];
    if(value == nil || value == NSNoSelectionMarker){
        return nil;
    }
    return value;
                
}

- (IBAction)clickFontNameBtn:(id)sender {
    currentFontName = [_fontB stringValue];
    [self setValue:currentFontName forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontName]];
}

- (IBAction)clickFontSize:(id)sender {
    currentFontSize = [_fontSizeComboBox integerValue];
    [self setValue:@(currentFontSize) forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagFontSize]];
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

#endif



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
