//
//  LMNotiMessageWC.m
//  IUEditor
//
//  Created by jd on 6/30/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMNotiMessageWC.h"

@interface LMNotiMessageWC ()

@end

@implementation LMNotiMessageWC

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
- (IBAction)performOK:(id)sender {
    [self close];
}

- (IBAction)performDoNotShow:(NSButton*)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.state forKey:self.idString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
