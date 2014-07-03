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
@property (weak) IBOutlet PDFThumbnailView *pdfThumbnailV;

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
    
    [_pdfThumbnailV setMaximumNumberOfColumns:1];
    [_pdfThumbnailV setThumbnailSize:NSMakeSize(150, 100)];
    
    if(documentFileName){
        [self setHelpDocument:documentFileName title:nil];
    }
}

- (void)setHelpDocument:(NSString*)fileName title:(NSString *)title{
    documentFileName = fileName;
    if([[fileName pathExtension] isEqualToString:@"pdf"]){
        NSURL *url = [[NSBundle mainBundle] URLForResource:[fileName stringByDeletingPathExtension] withExtension:@"pdf"];
        PDFDocument *doc = [[PDFDocument alloc] initWithURL:url];
        [self.pdfV setDocument:doc];
    }
    
    if(title){
        [[self window] setTitle:[NSString stringWithFormat:@"Manual For %@", title]];
    }
    else{
        [[self window] setTitle:@"Manual"];
    }
}

- (void)setHelpDocumentWithKey:(NSString *)key{
    //pdf list
    NSString *pdfFilePath = [[NSBundle mainBundle] pathForResource:@"helpPdf" ofType:@"plist"];
    NSDictionary *pdfDict = [NSDictionary dictionaryWithContentsOfFile:pdfFilePath];

    NSString *fileName = [pdfDict objectForKey:key][@"pdf"];
    NSString *title= [pdfDict objectForKey:key][@"title"];
    
    [self setHelpDocument:fileName title:title];

}

@end
