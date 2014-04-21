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
    [_variableTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"variable"] options:nil];
    [_altTextTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"altText"] options:nil];
    
    [_imageResourceComboBox bind:@"content" toObject:self withKeyPath:@"resourceManager.imageNames" options:nil];
    [_imageResourceComboBox bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"imageName"] options:nil];

}

@end
