//
//  LMPropertyBaseVC.m
//  IUEditor
//
//  Created by JD on 4/5/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyBGImageVC.h"

@interface LMPropertyBGImageVC ()

@property (weak) IBOutlet NSComboBox *imageNameComboBox;
@property (weak) IBOutlet NSTextField *xPositionTF;
@property (weak) IBOutlet NSTextField *yPositionTF;

@property (weak) IBOutlet NSPopUpButton *sizeB;

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

- (NSString*)CSSBindingPath:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}

- (void)awakeFromNib{

    [_imageNameComboBox bind:@"content" toObject:self withKeyPath:@"resourceManager.imageNames" options:nil];
    [_imageNameComboBox bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagImage] options:nil];
    
    [_xPositionTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBGXPosition] options:nil];
    [_yPositionTF bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBGYPosition] options:nil];
    
    [_sizeB bind:@"selectedValue" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBGSize] options:nil];
    
    
}



@end
