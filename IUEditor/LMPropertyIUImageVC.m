//
//  LMPropertyIUImageVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUImageVC.h"

@interface LMPropertyIUImageVC ()

@property (weak) IBOutlet NSTextField *variableTF;
@property (weak) IBOutlet NSTextField *altTextTF;
@property (weak) IBOutlet NSComboBox *imageResourceComboBox;

@end

@implementation LMPropertyIUImageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    
    NSDictionary *bindingOption = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO]]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption]];

    [_variableTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"variable"] options:bindingOption];
    [_altTextTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"altText"] options:bindingOption];
    
    [_imageResourceComboBox bind:@"content" toObject:self withKeyPath:@"resourceManager.imageNames" options:bindingOption];
    [_imageResourceComboBox bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"imageName"] options:bindingOption];

}

@end
