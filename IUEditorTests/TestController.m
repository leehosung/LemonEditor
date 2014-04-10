//
//  TestController.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 24..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "TestController.h"

@implementation TestView: NSView

/*
- (NSDraggingSession *)beginDraggingSessionWithItems:(NSArray *)items event:(NSEvent *)event source:(id<NSDraggingSource>)source {
//    [pboard declareTypes:[NSArray arrayWithObject:kUTTypeIUType] owner:self];
//    [pboard setString:@"test" forType:(id)kUTTypeIUType];
}

 */
- (IBAction)clickDragBtn:(id)sender {
    NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    [pboard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType]  owner:self];
    [pboard setData:[[self.imageV image] TIFFRepresentation] forType:NSTIFFPboardType];
    
    [self dragImage:[self.imageV image] at:self.imageV.frame.origin offset:self.imageV.frame.size
              event:nil pasteboard:pboard source:self slideBack:YES];
}
@end


@interface TestController ()

@end

@implementation TestController

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
    
    self.cssStr = @"#test{ position:absolute; width:100px; height:100px; top:200px; left:50px; background-color:blue;}";
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

/*

- (IBAction)clickCSSBtn:(id)sender {
    if(self.cssSize != nil){
        NSInteger size =[self.cssSize integerValue];
        [((LMWC *)self.mainWC) setIUStyle:self.cssStr withID:@"test" size:size];
    }else{
        [((LMWC *)self.mainWC) setIUStyle:self.cssStr withID:@"test"];
    }
}

- (IBAction)clickHTMLBtn:(id)sender {
    [((LMWC *)self.mainWC) setIUInnerHTML:self.htmlStr withParentID:@"test" tag:@"div"];
}

- (IBAction)clickRemoveHTMLBtn:(id)sender {
    if(self.removeID){
        [((LMWC *)self.mainWC)  removeIU:self.removeID];
    }
}
 */



@end
