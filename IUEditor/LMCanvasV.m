//
//  LMCanvasV.m
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMCanvasV.h"
#import <WebKit/WebKit.h>

@implementation LMCanvasV{
    WebView *webView;
}

-(id)init{
    self = [super init];
    webView = [[WebView alloc] init];
    [self addSubviewFullFrame:webView];
    return self;
}

- (void)setDocument:(IUDocument *)document{
    NSAssert(self.resourcePath != nil, @"resourcePath is nil");
    [_document setCanvas:nil];
    _document = document;
    [_document setCanvas:self];
    
    NSString *outputSource = _document.outputSource;
    
    [[webView mainFrame] loadHTMLString:outputSource baseURL:[NSURL fileURLWithPath:self.resourcePath]];
}


@end