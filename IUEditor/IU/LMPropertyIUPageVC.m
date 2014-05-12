//
//  LMPropertyIUPageVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 12..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUPageVC.h"

@interface LMPropertyIUPageVC ()
@property (weak) IBOutlet NSTextField *titleTF;
@property (weak) IBOutlet NSTextField *keywordsTF;
@property (weak) IBOutlet NSTextField *authorTF;
@property (unsafe_unretained) IBOutlet NSTextView *descriptionTV;

@end

@implementation LMPropertyIUPageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_titleTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"title"]  options:IUBindingDictNotRaisesApplicable];
    [_keywordsTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"keywords"]  options:IUBindingDictNotRaisesApplicable];
    [_authorTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"author"]  options:IUBindingDictNotRaisesApplicable];
    
    NSDictionary *bindingOption = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSContinuouslyUpdatesValueBindingOption]];

    
    [_descriptionTV bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"description"]  options:bindingOption];

}

@end
