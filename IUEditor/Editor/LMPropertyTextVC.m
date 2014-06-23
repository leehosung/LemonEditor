//
//  LMPropertyTextVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 20..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyTextVC.h"

@interface LMPropertyTextVC ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation LMPropertyTextVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

    [_textView bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"text"] options:bindingOption];

    
}

- (void)performFocus:(NSNotification *)noti{
    [self.view.window makeFirstResponder:_textView];
}

@end
