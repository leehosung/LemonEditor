//
//  LMPreferenceWC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 28..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPreferenceWC.h"
#import "LMFontPreferenceVC.h"

@interface LMPreferenceWC ()

@property (weak) IBOutlet NSTabView *preferenceTabView;

//FONT preference
@property LMFontPreferenceVC *fontVC;
@property (weak) IBOutlet NSView *fontV;


@end

@implementation LMPreferenceWC

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

#pragma mark - font preference
    _fontVC = [[LMFontPreferenceVC alloc] initWithNibName:[LMFontPreferenceVC class].className bundle:nil];
    [_fontV addSubviewFullFrame:_fontVC.view];
}

- (IBAction)selectFontTabView:(id)sender {
    [_preferenceTabView selectTabViewItemWithIdentifier:@"fontVC"];
}

@end
