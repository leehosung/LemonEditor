
//
//  LMPropertyBGImageVC.m
//  IUEditor
//
//  Created by JD on 4/5/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyBGImageVC.h"
#import "IUImage.h"

@interface LMPropertyBGImageVC ()

@property (weak) IBOutlet NSComboBox *imageNameComboBox;
@property (weak) IBOutlet NSTextField *xPositionTF;
@property (weak) IBOutlet NSTextField *yPositionTF;

@property (weak) IBOutlet NSSegmentedControl *sizeSegementControl;

@property (weak) IBOutlet NSPopUpButton *sizeB;
@property (weak) IBOutlet NSButton *repeatBtn;

@end

@implementation LMPropertyBGImageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{

    [_imageNameComboBox bind:NSContentBinding toObject:self withKeyPath:@"resourceManager.imageFiles" options:IUBindingDictNotRaisesApplicable];
    [_imageNameComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:IUBindingDictNotRaisesApplicable];
    _imageNameComboBox.delegate = self;
    
    [_xPositionTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGXPosition] options:IUBindingDictNotRaisesApplicable];
    [_yPositionTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGYPosition] options:IUBindingDictNotRaisesApplicable];
    
    [_sizeSegementControl bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGSize] options:IUBindingDictNotRaisesApplicable];
    [_repeatBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGRepeat] options:IUBindingDictNotRaisesApplicable];
    
    //enable
    NSDictionary *bgEnableBindingOption = [NSDictionary
                                            dictionaryWithObjects:@[NSIsNotNilTransformerName]
                                            forKeys:@[NSValueTransformerNameBindingOption]];
    
    [_xPositionTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    [_yPositionTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    [_sizeSegementControl bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    [_repeatBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:0 context:@"image"];
    
    
}

- (void)controlTextDidChange:(NSNotification *)obj{
    for (IUImage *image in self.controller.selectedObjects) {
        if ([image isKindOfClass:[IUImage class]]) {
            id value = [_imageNameComboBox stringValue];
            [image setImageName:value];
        }
    }
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    for (IUImage *image in self.controller.selectedObjects) {
        if ([image isKindOfClass:[IUImage class]]) {
            id value = [_imageNameComboBox objectValueOfSelectedItem];
            [image setImageName:value];
        }
    }
}



@end
