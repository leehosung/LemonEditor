//
//  LMHelpWC.m
//  IUEditor
//
//  Created by jd on 6/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPDFHelpWC.h"
#import <Quartz/Quartz.h>

static LMPDFHelpWC *gHelpWC = nil;

@interface LMPDFHelpWC ()

@property (weak) IBOutlet PDFView *pdfV;
@property (weak) IBOutlet PDFThumbnailView *pdfThumbnailV;
@property (weak) IBOutlet NSTableView *pdfListTableView;

@property (strong) IBOutlet NSDictionaryController *pdfListDictController;
@property NSDictionary *pdfListDictionary;

@end

@implementation LMPDFHelpWC{
}

+ (LMPDFHelpWC *)sharedPDFHelpWC{
    if(gHelpWC == nil){
        gHelpWC = [[LMPDFHelpWC alloc] initWithWindowNibName:[LMPDFHelpWC class].className];
    }
    return gHelpWC;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [self loadWindow];
        NSString *pdfFilePath = [[NSBundle mainBundle] pathForResource:@"helpPdf" ofType:@"plist"];
        _pdfListDictionary = [NSDictionary dictionaryWithContentsOfFile:pdfFilePath];

    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [_pdfListDictController setContent:_pdfListDictionary];
    
    [_pdfThumbnailV setMaximumNumberOfColumns:1];
    [_pdfThumbnailV setThumbnailSize:NSMakeSize(150, 100)];
    
}

- (void)setHelpDocument:(NSString*)fileName title:(NSString *)title{
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
    
    NSString *currentKey = [_pdfListDictController.selectedObjects[0] key];
    //FIXME: selection tableView
    
/*    if([key isEqualToString:currentKey] == NO){
        NSDictionary *dict = [NSDictionary dictionaryWithObject:_pdfListDictionary[key] forKey:key];
        [_pdfListDictController setSelectedObjects:@[dict]];
    }
 */
    
    //pdf list
    NSString *fileName = [_pdfListDictionary objectForKey:key][@"pdf"];
    NSString *title= [_pdfListDictionary objectForKey:key][@"title"];
    
    [self setHelpDocument:fileName title:title];

}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSString *key = [[_pdfListDictController selectedObjects][0] key];
    [self setHelpDocumentWithKey:key];
}


@end
