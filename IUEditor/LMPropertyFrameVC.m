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
@property (weak) IBOutlet NSButton *flowB;
@property (weak) IBOutlet NSButton *rightB;
@property (weak) IBOutlet NSButton *centerB;

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
    [_pxTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnit] options:percentHiddeBindingOption];
    [_yTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnit] options:IUBindingDictNotRaisesApplicable];
    [_pyTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnit] options:percentHiddeBindingOption];
    [_wTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnit] options:IUBindingDictNotRaisesApplicable];
    [_pwTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnit] options:percentHiddeBindingOption];
    [_hTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnit] options:IUBindingDictNotRaisesApplicable];
    [_phTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnit] options:percentHiddeBindingOption];


    [_flowB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"flow"] options:IUBindingDictNotRaisesApplicable];
    [_flowB bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"flowChangeable"] options:IUBindingDictNotRaisesApplicable];
    
    [_rightB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"floatRight"] options:IUBindingDictNotRaisesApplicable];
    [_rightB bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"floatRightChangeable"] options:IUBindingDictNotRaisesApplicable];

    [_centerB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:IUBindingDictNotRaisesApplicable];
    [_centerB bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"centerChangeable"] options:IUBindingDictNotRaisesApplicable];

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
    
    [_xTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableXUserInput"] options:bindingOption];
    [_yTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableYUserInput"] options:bindingOption];
    [_wTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableWidthUserInput"] options:bindingOption];
    [_hTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableHeightUserInput"] options:bindingOption];
    
    [_pxTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableXUserInput"] options:bindingOption];
    [_pyTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableYUserInput"] options:bindingOption];
    [_pwTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableWidthUserInput"] options:bindingOption];
    [_phTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableHeightUserInput"] options:bindingOption];

    
    [_xUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableXUserInput"] options:bindingOption];
    [_yUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableYUserInput"] options:bindingOption];
    [_wUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableWidthUserInput"] options:bindingOption];
    [_hUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableHeightUserInput"] options:bindingOption];
    
    
    bindingOption = [NSDictionary
                     dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSNegateBooleanTransformerName]
                     forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];
    
    [_xTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_pxTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_xUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([[keyPath pathExtension] isSameTag:IUCSSTagX]) {
        [self setValueForTag:IUCSSTagX toTextfield:_xTF];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagY]) {
        [self setValueForTag:IUCSSTagY toTextfield:_yTF];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagWidth]) {
        [self setValueForTag:IUCSSTagWidth toTextfield:_wTF];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagHeight]) {
        [self setValueForTag:IUCSSTagHeight toTextfield:_hTF];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentX]) {
        [self setValueForTag:IUCSSTagPercentX toTextfield:_pxTF];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentY]) {
        [self setValueForTag:IUCSSTagPercentY toTextfield:_pyTF];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentWidth]) {
        [self setValueForTag:IUCSSTagPercentWidth toTextfield:_pwTF];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentHeight]) {
        [self setValueForTag:IUCSSTagPercentHeight toTextfield:_phTF];
    }
    else {
        assert(0);
    }
}

- (void)setValueForTag:(IUCSSTag)tag toTextfield:(NSTextField*)textfield{
    id value = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:tag]];
    if (value && [value isEqual:textfield.stringValue] == NO){
        [textfield setStringValue:value];
    }
    else if (value == nil || value == NSNoSelectionMarker){
        [textfield setStringValue:@"-"];
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
    
    if ([[control stringValue] isEqualToString:@"-"]) {
        for (IUBox *box in _controller.selectedObjects) {
            [box.css eradicateTag:tag];
        }
    }
    else {
        [self setValue:[control stringValue] forKeyPath:[_controller keyPathFromControllerToCSSTag:tag]];
    }
    for (IUBox *iu in _controller.selectedObjects) {
        [iu updateCSSForEditViewPort];
    }
    return YES;
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    NSLog([NSString stringWithFormat:@"LMPropertyFrame VC : %@, %@", keyPath, [value description]], nil);
    [super setValue:value forKeyPath:keyPath];
}

@end
