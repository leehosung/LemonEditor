//
//  LMPreferenceWC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 28..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPreferenceWC.h"
#import "LMPreferenceFontVC.h"
#import "LMPreferenceDjangoVC.h"

@interface LMPreferenceWC ()

//FONT preference
@property (weak) IBOutlet NSView *mainV;
@end

@implementation LMPreferenceWC{
    NSViewController    *currentVC;
    LMPreferenceFontVC  *fontVC;
    LMPreferenceDjangoVC    *djangoVC;
}

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
    fontVC = [[LMPreferenceFontVC alloc] initWithNibName:[LMPreferenceFontVC class].className bundle:nil];
    djangoVC = [[LMPreferenceDjangoVC alloc] initWithNibName:[LMPreferenceDjangoVC class].className bundle:nil];
    [self performShowFont:self];
}

- (IBAction)performShowFont:(id)sender {
    [currentVC.view removeFromSuperview];
    currentVC = fontVC;
    [_mainV addSubviewFullFrame:currentVC.view];
}


- (IBAction)performShowDjango:(id)sender {
    [currentVC.view removeFromSuperview];
    currentVC = djangoVC;
    [_mainV addSubviewFullFrame:djangoVC.view];
}

@end
