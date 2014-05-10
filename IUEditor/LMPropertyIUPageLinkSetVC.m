//
//  IUPageLinkSetVC.m
//  IUEditor
//
//  Created by jd on 5/8/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyIUPageLinkSetVC.h"

@interface LMPropertyIUPageLinkSetVC ()
@property (weak) IBOutlet NSTextField *pageCountTF;
@property (weak) IBOutlet NSTextField *marginTF;
@property (weak) IBOutlet NSColorWell *defaultColorWell;
@property (weak) IBOutlet NSColorWell *selectedColorWell;
@property (weak) IBOutlet NSSegmentedControl *alignSC;

@end

@implementation LMPropertyIUPageLinkSetVC

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
    [_pageCountTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"pageCountVariable"]  options:bindingOption];
    
    [_marginTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"buttonMargin"]  options:bindingOption];
    
    [_defaultColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"defaultButtonBGColor"]  options:bindingOption];
    
    [_selectedColorWell bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"selectedButtonBGColor"]  options:bindingOption];

    [_alignSC bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"pageLinkAlign"] options:bindingOption];
}

- (IBAction)clearDefaultColorPressed:(id)sender {
    [self setValue:nil forKey:[_controller keyPathFromControllerToProperty:@"defaultButtonBGColor"]];
}
- (IBAction)clearSelectedColorPressed:(id)sender {
    [self setValue:nil forKey:[_controller keyPathFromControllerToProperty:@"selectedButtonBGColor"]];
}
@end
