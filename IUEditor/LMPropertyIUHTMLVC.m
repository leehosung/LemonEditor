//
//  LMPropertyIUHTMLVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUHTMLVC.h"

@interface LMPropertyIUHTMLVC ()

@property (unsafe_unretained) IBOutlet NSTextView *innerHTMLTextV;

@end

@implementation LMPropertyIUHTMLVC

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
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSContinuouslyUpdatesValueBindingOption]];
    [_innerHTMLTextV bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"innerHTML"]  options:bindingOption];
    [_innerHTMLTextV setEnabledTextCheckingTypes:0];
}

- (void)performFocus:(NSNotification*)noti{
    [self.view.window makeFirstResponder:_innerHTMLTextV];
}


@end
