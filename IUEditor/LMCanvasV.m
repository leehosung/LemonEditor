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

//FIXME: not called.
- (void)setDocument:(IUDocument *)document{
    assert(0); //is this function called?
    NSAssert(self.resourcePath != nil, @"resourcePath is nil");
    JDSectionInfoLog(IULogSource, @"resourcePath : %@", self.resourcePath);
    [_document setDelegate:nil];
    _document = document;
    [_document setDelegate:self];
    
    [[webView mainFrame] loadHTMLString:document.editorSource baseURL:[NSURL fileURLWithPath:self.resourcePath]];
}

-(void)IU:(NSString *)identifier CSSChanged:(NSString *)css forWidth:(int)width{
    NSLog(@"_____________ YOU SHOULD CODE HERE ___________");
}

@end