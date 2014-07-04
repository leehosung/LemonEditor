//
//  LMInspectorAltTextVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 24..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMInspectorAltTextVC.h"

@interface LMInspectorAltTextVC ()

@property (weak) IBOutlet NSTextField *altTextTF;

@end

@implementation LMInspectorAltTextVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_altTextTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"altText"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];

}
@end
