//
//  LMPropertyBaseVC.m
//  IUEditor
//
//  Created by JD on 4/5/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyBaseVC.h"

@interface LMPropertyBaseVC ()
@property (weak) IBOutlet NSComboBox *imageNameComboBox;

@end

@implementation LMPropertyBaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    //IUController.selection.css.affectingTagCollection.width
    [_imageNameComboBox bind:@"content" toObject:self withKeyPath:@"resourceManager.imageNames" options:nil];
    
    NSString *imageCSSBindingPath = [@"IUController.selection.css.affectingTagCollection." stringByAppendingString:IUCSSTagImage];
    [_imageNameComboBox bind:@"value" toObject:self withKeyPath:imageCSSBindingPath options:nil];
}

@end
