//
//  LMStartWC.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartWC.h"
#import "LMAppDelegate.h"

@interface LMStartWC ()

@end

@implementation LMStartWC

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)pressDefaultNew:(id)sender {
    LMAppDelegate *delegate = [NSApplication sharedApplication].delegate;
}
- (IBAction)pressDjangoNew:(id)sender {
}
- (IBAction)pressDefaultLoad:(id)sender {
}
- (IBAction)pressDjangoLoad:(id)sender {
}

@end
