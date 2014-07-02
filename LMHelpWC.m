//
//  LMHelpWC.m
//  IUEditor
//
//  Created by jd on 6/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMHelpWC.h"
#import <Quartz/Quartz.h>

@interface LMHelpWC ()
@property (weak) IBOutlet PDFView *pdfV;

@end

@implementation LMHelpWC{
    NSString *documentFileName;
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
    if (documentFileName) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:[documentFileName stringByDeletingPathExtension] withExtension:@"pdf"];
        PDFDocument *doc = [[PDFDocument alloc] initWithURL:url];
        [self.pdfV setDocument:doc];
    }
}

- (void)setHelpDocument:(NSString*)fileName{
    documentFileName = fileName;
    if([[fileName pathExtension] isEqualToString:@"pdf"]){
        NSURL *url = [[NSBundle mainBundle] URLForResource:[fileName stringByDeletingPathExtension] withExtension:@"pdf"];
        PDFDocument *doc = [[PDFDocument alloc] initWithURL:url];
        [self.pdfV setDocument:doc];
    }
}


@end
