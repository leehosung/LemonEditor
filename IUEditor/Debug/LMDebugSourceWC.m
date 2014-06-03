//
//  LMDebugSourceWC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMDebugSourceWC.h"

@interface LMDebugSourceWC ()

@end

@implementation LMDebugSourceWC


- (instancetype)initWithWindow:(NSWindow *)window
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
- (IBAction)applyCurrentSource:(id)sender {
    NSString *html = [_codeTextView string];
    [_canvasVC applyHtmlString:html];
}
- (IBAction)reloadOriginalSource:(id)sender {
    [_canvasVC reloadOriginalDocument];
}

@end
