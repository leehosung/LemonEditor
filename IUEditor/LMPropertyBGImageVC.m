
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
    [_imageNameComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"imageName"] options:IUBindingDictNotRaisesApplicable];
    _imageNameComboBox.delegate = self;
    
    [_xPositionTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGXPosition] options:IUBindingDictNotRaisesApplicable];
    [_yPositionTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGYPosition] options:IUBindingDictNotRaisesApplicable];
    
    [_sizeSegementControl bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGSize] options:IUBindingDictNotRaisesApplicable];

    
    NSDictionary *noRepeatBindingOption = [NSDictionary
                                               dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSNegateBooleanTransformerName]
                                               forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];
    
    [_repeatBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGRepeat] options:noRepeatBindingOption];
    
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

- (void)dealloc{
    //release 시점 확인용
    assert(0);
  //  [self removeObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage]];
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


- (IBAction)performFitToImage:(id)sender { // Fit to Image button function
    assert(_resourceManager);

    //image filename
    NSString *filename = _imageNameComboBox.stringValue;
    
    //getting path
    IUResourceFile *file = [_resourceManager resourceFileWithName:filename];
    NSString *path = file.absolutePath;
    NSLog(@"%@", path);
    
    //getting size
    NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:path];
    
    NSInteger width = 0;
    NSInteger height = 0;
    
    for (NSImageRep * imageRep in imageReps) {
        if ([imageRep pixelsWide] > width) width = [imageRep pixelsWide];
        if ([imageRep pixelsHigh] > height) height = [imageRep pixelsHigh];
    }
    
    //setting size to IU
    NSArray *selectedObjects = self.controller.selectedObjects;

    for (IUBox *box in selectedObjects) {
        [box.css setValue:@(width) forTag:IUCSSTagWidth];
        [box.css setValue:@(height) forTag:IUCSSTagHeight];
        [box updateCSSForEditViewPort];
    }
}

@end
