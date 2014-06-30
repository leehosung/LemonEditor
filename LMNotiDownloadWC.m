//
//  LMNotiDownloadWC.m
//  IUEditor
//
//  Created by jd on 6/30/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMNotiDownloadWC.h"

@interface LMNotiDownloadWC ()

@end

@implementation LMNotiDownloadWC

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

- (IBAction)perfromUpdate:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:_downloadURLString]];
}


@end
