//
//  LMHelpWC.m
//  IUEditor
//
//  Created by jd on 6/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMHelpWC.h"
#import <Quartz/Quartz.h>
#import <WebKit/WebKit.h>

static LMHelpWC *gHelpWC = nil;

@interface LMHelpWC ()

@property (weak) IBOutlet NSView *pdfEmbedV;
@property (weak) IBOutlet NSView *webEmbedV;
@property (weak) IBOutlet WebView *webV;
@property (weak) IBOutlet PDFView *pdfV;
@property (weak) IBOutlet PDFThumbnailView *pdfThumbnailV;
@property (weak) IBOutlet NSTableView *pdfListTableView;

@property (strong) IBOutlet NSDictionaryController *pdfListDictController;
@property NSDictionary *pdfListDictionary;

@end

@implementation LMHelpWC{
    BOOL windowLoaded;
}

+ (LMHelpWC *)sharedHelpWC{
    if(gHelpWC == nil){
        gHelpWC = [[LMHelpWC alloc] initWithWindowNibName:[LMHelpWC class].className];
    }
    return gHelpWC;
}

- (void)showHelpWebURL:(NSURL*)url withTitle:(NSString *)title{
    if (self.window == nil) {
        [self window];
    }

    self.window.title = title;
    
    [_pdfEmbedV setHidden:YES];
    [_webEmbedV setHidden:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[self.webV mainFrame] loadRequest:request];
    [self.window makeKeyAndOrderFront:nil];
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
    windowLoaded = YES;
}

- (void)showHelpDocument:(NSString*)fileName title:(NSString *)title{
    if (self.window == nil) {
        [self window];
    }
    
    [_webEmbedV setHidden:YES];
    [_pdfEmbedV setHidden:NO];
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

- (void)showHelpDocumentWithKey:(NSString *)key{
   // NSString *currentKey = [_pdfListDictController.selectedObjects[0] key];
    //FIXME: selection tableView
    
/*    if([key isEqualToString:currentKey] == NO){
        NSDictionary *dict = [NSDictionary dictionaryWithObject:_pdfListDictionary[key] forKey:key];
        [_pdfListDictController setSelectedObjects:@[dict]];
    }
 */
    
    //pdf list
    
    if (self.window == nil) {
        [self window];
    }

    NSString *fileName = [_pdfListDictionary objectForKey:key][@"pdf"];
    NSString *title= [_pdfListDictionary objectForKey:key][@"title"];
    
    [self showHelpDocument:fileName title:title];

    [self.window makeKeyAndOrderFront:nil];

}
/*
- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSString *key = [[_pdfListDictController selectedObjects][0] key];
    [self showHelpDocumentWithKey:key];
}
*/

@end
