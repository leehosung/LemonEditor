//
//  LMPropertyVC.m
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyFrameVC.h"
#import "IUBox.h"
#import "IUCSS.h"
#import "LMPDFHelpWC.h"
#import "IUPageContent.h"

@interface LMPropertyFrameVC ()

//pixel TextField
@property (weak) IBOutlet NSTextField *xTF;
@property (weak) IBOutlet NSTextField *yTF;
@property (weak) IBOutlet NSTextField *wTF;
@property (weak) IBOutlet NSTextField *hTF;

//percent TextField
@property (weak) IBOutlet NSTextField *pxTF;
@property (weak) IBOutlet NSTextField *pyTF;
@property (weak) IBOutlet NSTextField *pwTF;
@property (weak) IBOutlet NSTextField *phTF;

//pixel stepper
@property (weak) IBOutlet NSStepper *xStepper;
@property (weak) IBOutlet NSStepper *yStepper;
@property (weak) IBOutlet NSStepper *wStepper;
@property (weak) IBOutlet NSStepper *hStepper;

//percent stepper
@property (weak) IBOutlet NSStepper *pxStepper;
@property (weak) IBOutlet NSStepper *pyStepper;
@property (weak) IBOutlet NSStepper *pwStepper;
@property (weak) IBOutlet NSStepper *phStepper;


@property (weak) IBOutlet NSButton *xUnitBtn;
@property (weak) IBOutlet NSButton *yUnitBtn;
@property (weak) IBOutlet NSButton *wUnitBtn;
@property (weak) IBOutlet NSButton *hUnitBtn;


@property (weak) IBOutlet NSButton *helpMenu;
@property (weak) IBOutlet NSPopUpButton *positionPopupBtn;

@property (nonatomic) BOOL enablePercentH, enablePosition;

- (IBAction)helpMenu:(id)sender;


@end

@implementation LMPropertyFrameVC{
    LMPDFHelpWC *helpWC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _enablePercentH = YES;
        _enablePosition = YES;
        [self loadView];
    }
    return self;
}


- (void)setController:(IUController *)controller{
    _controller = controller;
    //observing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMQSelect:) name:IUNotificationMQSelected object:nil];

    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:0 context:nil];


    //binding
    NSDictionary *percentHiddeBindingOption = [NSDictionary
                                            dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSNegateBooleanTransformerName]
                                            forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];

    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagX] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagY] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidth] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeight] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPercentX] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPercentY] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPercentWidth] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPercentHeight] options:0 context:nil];
    
    [_xTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnit] options:IUBindingDictNotRaisesApplicable];
    [_xStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnit] options:IUBindingDictNotRaisesApplicable];
    [_pxTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnit] options:percentHiddeBindingOption];
    [_pxStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnit] options:percentHiddeBindingOption];
    
    [_yTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnit] options:IUBindingDictNotRaisesApplicable];
    [_yStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnit] options:IUBindingDictNotRaisesApplicable];
    [_pyTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnit] options:percentHiddeBindingOption];
    [_pyStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnit] options:percentHiddeBindingOption];
    
    [_wTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnit] options:IUBindingDictNotRaisesApplicable];
    [_wStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnit] options:IUBindingDictNotRaisesApplicable];
    [_pwTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnit] options:percentHiddeBindingOption];
    [_pwStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnit] options:percentHiddeBindingOption];
    
    [_hTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnit] options:IUBindingDictNotRaisesApplicable];
    [_hStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnit] options:IUBindingDictNotRaisesApplicable];
    [_phTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnit] options:percentHiddeBindingOption];
    [_phStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnit] options:percentHiddeBindingOption];


    
    [_xUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnit] options:IUBindingDictNotRaisesApplicable];
    [_yUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnit] options:IUBindingDictNotRaisesApplicable];
    [_wUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnit] options:IUBindingDictNotRaisesApplicable];
    [_hUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnit] options:IUBindingDictNotRaisesApplicable];
    
    [_positionPopupBtn bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"positionType"] options:IUBindingDictNotRaisesApplicable];
    

    //enabled option 1
    [_xTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_yTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_wTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_hTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];
    
    [_pxTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_pyTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_pwTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_phTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];
    
    [_xUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_yUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_wUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_hUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];
    
    [_xStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_yStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_wStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_hStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];
    
    [_pxStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_pyStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_pwStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_phStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];

    
    [_positionPopupBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangePositionType"] options:IUBindingDictNotRaisesApplicable];
    //enabled option 2
    
    [_xTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_yTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_wTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_hTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];
    
    [_pxTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_pyTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_pwTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_phTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];
    
    [_xUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_yUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_wUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_hUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];
    
    [_xStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_yStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_wStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_hStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];

    [_pxStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_pyStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_pwStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_phStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];
    
    [_positionPopupBtn bind:@"enabled2" toObject:self withKeyPath:@"enablePosition" options:IUBindingDictNotRaisesApplicable];

    
    
    //enabled option 3
    NSDictionary *bindingOption = [NSDictionary
                     dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSNegateBooleanTransformerName]
                     forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];
    
    [_xTF bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_pxTF bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_xUnitBtn bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_xStepper bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_pxStepper bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];

    [_hUnitBtn bind:@"enabled3" toObject:self withKeyPath:@"enablePercentH" options:IUBindingDictNotRaisesApplicable];
}

- (void)dealloc{
    //release 시점 확인용
    assert(0);
}

- (void)changeMQSelect:(NSNotification *)notification{
    NSInteger selectedSize = [[notification.userInfo valueForKey:IUNotificationMQSize] integerValue];
    NSInteger maxSize = [[notification.userInfo valueForKey:IUNotificationMQMaxSize] integerValue];
    if(selectedSize == maxSize){
        self.enablePosition = YES;
    }
    else{
        self.enablePosition = NO;
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([[keyPath pathExtension] isSameTag:IUCSSTagX]) {
        [self setValueForTag:IUCSSTagX toTextfield:_xTF toStepper:_xStepper];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagY]) {
        [self setValueForTag:IUCSSTagY toTextfield:_yTF toStepper:_yStepper];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagWidth]) {
        [self setValueForTag:IUCSSTagWidth toTextfield:_wTF toStepper:_wStepper];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagHeight]) {
        [self setValueForTag:IUCSSTagHeight toTextfield:_hTF toStepper:_hStepper];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentX]) {
        [self setValueForTag:IUCSSTagPercentX toTextfield:_pxTF toStepper:_pxStepper];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentY]) {
        [self setValueForTag:IUCSSTagPercentY toTextfield:_pyTF toStepper:_pyStepper];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentWidth]) {
        [self setValueForTag:IUCSSTagPercentWidth toTextfield:_pwTF toStepper:_pwStepper];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentHeight]) {
        [self setValueForTag:IUCSSTagPercentHeight toTextfield:_phTF toStepper:_phStepper];
    }
    else if ([keyPath isEqualToString:@"controller.selectedObjects"]){
        [self checkForIUPageContent];
    }
    else {
        assert(0);
    }
}

- (void)checkForIUPageContent{
    BOOL isPageContentChildren = NO;
    for (IUBox *iu in _controller.selectedObjects) {
        if([iu.parent isKindOfClass:[IUPageContent class]]){
            isPageContentChildren = YES;
            break;
        }
    }

    self.enablePercentH = !isPageContentChildren;
}

- (void)setValueForTag:(IUCSSTag)tag toTextfield:(NSTextField*)textfield toStepper:(NSStepper *)stepper{
    id value = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:tag]];
    //default setting
    [[textfield cell] setPlaceholderString:@""];
   
    if (value == nil || value == NSNoSelectionMarker || value == NSMultipleValuesMarker || value == NSNotApplicableMarker){
        if(value){
            
            //placehoder setting
            NSString *placeholder = [NSString stringWithValueMarker:value];
            [[textfield cell] setPlaceholderString:placeholder];
            [textfield setStringValue:@""];

        }
        else{
            [textfield setStringValue:@"-"];
        }
        [stepper setEnabled:NO];
    }
    else{
        if(value && [value isEqual:textfield.stringValue] == NO){
            [textfield setStringValue:value];
        }
        [stepper setEnabled:YES];
        [stepper setIntegerValue:[value integerValue]];
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    IUCSSTag tag;
    if (control == _xTF) {
        tag = IUCSSTagX;
    }
    else if (control == _pxTF) {
        tag = IUCSSTagPercentX;
    }
    else if (control == _yTF) {
        tag = IUCSSTagY;
    }
    else if (control == _pyTF) {
        tag = IUCSSTagPercentY;
    }
    else if (control == _wTF) {
        tag = IUCSSTagWidth;
    }
    else if (control == _pwTF) {
        tag = IUCSSTagPercentWidth;
    }
    else if (control == _hTF) {
        tag = IUCSSTagHeight;
    }
    else if (control == _phTF) {
        tag = IUCSSTagPercentHeight;
    }
    
    [self setCSSFrameValue:[control stringValue] forTag:tag];
    
    return YES;
}
- (IBAction)clickStepper:(id)sender {
    IUCSSTag tag;

    if (sender == _xStepper) {
        tag = IUCSSTagX;
    }
    else if (sender == _pxStepper) {
        tag = IUCSSTagPercentX;
    }
    else if (sender == _yStepper) {
        tag = IUCSSTagY;
    }
    else if (sender == _pyStepper) {
        tag = IUCSSTagPercentY;
    }
    else if (sender == _wStepper) {
        tag = IUCSSTagWidth;
    }
    else if (sender == _pwStepper) {
        tag = IUCSSTagPercentWidth;
    }
    else if (sender == _hStepper) {
        tag = IUCSSTagHeight;
    }
    else if (sender == _phStepper) {
        tag = IUCSSTagPercentHeight;
    }
    
    [self setCSSFrameValue:[sender stringValue] forTag:tag];
}

- (void)setCSSFrameValue:(id)value forTag:(IUCSSTag)tag{
    if ([value isEqualToString:@"-"]) {
        for (IUBox *box in _controller.selectedObjects) {
            [box.css eradicateTag:tag];
        }
    }
    else {
        [self setValue:value forKeyPath:[_controller keyPathFromControllerToCSSTag:tag]];
    }
    for (IUBox *iu in _controller.selectedObjects) {
        [iu updateCSSForEditViewPort];
    }
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    NSLog([NSString stringWithFormat:@"LMPropertyFrame VC : %@, %@", keyPath, [value description]], nil);
    [super setValue:value forKeyPath:keyPath];
}

- (IBAction)helpMenu:(id)sender {
    NSLog(@"this is help menu");
    helpWC = [LMPDFHelpWC sharedPDFHelpWC];
    [helpWC setHelpDocumentWithKey:@"positionProperty"];
    [helpWC showWindow:nil];
    [helpWC.window makeKeyAndOrderFront:self];
}

@end
