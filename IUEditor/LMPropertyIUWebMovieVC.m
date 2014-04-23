//
//  LMPropertyIUWebMovieVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUWebMovieVC.h"

@interface LMPropertyIUWebMovieVC ()

@property (unsafe_unretained) IBOutlet NSTextView *webMovieSourceTextV;


@end

@implementation LMPropertyIUWebMovieVC

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
    
     [_webMovieSourceTextV bind:@"string" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"webMovieSource"]  options:bindingOption];

}

@end
