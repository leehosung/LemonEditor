//
//  CanvasWebView.h
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 21..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface WebCanvasView : WebView {
    DOMHTMLElement *currentNode;
}

@property id delegate;

//call javascript
- (void)updateFrameDict;
- (void)resizePageContent;

#pragma mark -

- (NSString *)IDOfCurrentIU;
- (NSString *)IUAtPoint:(NSPoint)point;
- (BOOL)isDOMTextAtPoint:(NSPoint)point;
- (void)changeDOMRange:(NSPoint)point;
@end
