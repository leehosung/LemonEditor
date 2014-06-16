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


@property (weak) IBOutlet NSButton *overflowB;

@property (nonatomic) BOOL enablePercentX, enablePercentY, enablePercentW, enablePercentH;



@end

@implementation LMPropertyFrameVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


-(void)awakeFromNib{

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

    [_overflowB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"overflow"] options:IUBindingDictNotRaisesApplicable];
    [_overflowB bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"overflowChangeable"] options:IUBindingDictNotRaisesApplicable];
    
    NSDictionary *bindingOption = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO]]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption]];


    
    [_xUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnit] options:bindingOption];
    [_yUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnit] options:bindingOption];
    [_wUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnit] options:bindingOption];
    [_hUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnit] options:bindingOption];


    //enabled option
    
    [_xTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:bindingOption];
    [_yTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:bindingOption];
    [_wTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:bindingOption];
    [_hTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:bindingOption];
    
    [_pxTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:bindingOption];
    [_pyTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:bindingOption];
    [_pwTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:bindingOption];
    [_phTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:bindingOption];
    
    [_xUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:bindingOption];
    [_yUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:bindingOption];
    [_wUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:bindingOption];
    [_hUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:bindingOption];
    
    [_xStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:bindingOption];
    [_yStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:bindingOption];
    [_wStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:bindingOption];
    [_hStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:bindingOption];
    
    [_pxStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:bindingOption];
    [_pyStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:bindingOption];
    [_pwStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:bindingOption];
    [_phStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:bindingOption];


    
    [_xTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:bindingOption];
    [_yTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:bindingOption];
    [_wTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:bindingOption];
    [_hTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:bindingOption];
    
    [_pxTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:bindingOption];
    [_pyTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:bindingOption];
    [_pwTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:bindingOption];
    [_phTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:bindingOption];
    
    [_xUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:bindingOption];
    [_yUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:bindingOption];
    [_wUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:bindingOption];
    [_hUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:bindingOption];
    
    [_xStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:bindingOption];
    [_yStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:bindingOption];
    [_wStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:bindingOption];
    [_hStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:bindingOption];

    [_pxStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:bindingOption];
    [_pyStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:bindingOption];
    [_pwStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:bindingOption];
    [_phStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:bindingOption];

    
    
    bindingOption = [NSDictionary
                     dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSNegateBooleanTransformerName]
                     forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];
    
    [_xTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_pxTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_xUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_xStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_pxStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
}

- (void)dealloc{
    //release 시점 확인용
    assert(0);
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
    else {
        assert(0);
    }
}

- (void)setValueForTag:(IUCSSTag)tag toTextfield:(NSTextField*)textfield toStepper:(NSStepper *)stepper{
    id value = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:tag]];
    if (value && [value isEqual:textfield.stringValue] == NO){
        [textfield setStringValue:value];
        [stepper setEnabled:YES];
        [stepper setIntegerValue:[value integerValue]];
    }
    else if (value == nil || value == NSNoSelectionMarker){
        [textfield setStringValue:@"-"];
        [stepper setEnabled:NO];
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

@end
