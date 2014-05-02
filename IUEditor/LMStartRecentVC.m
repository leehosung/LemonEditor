//
//  LMStartRecentVC.m
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartRecentVC.h"
#import "LMAppDelegate.h"

@interface LMStartRecentVC ()

@end

@implementation LMStartRecentVC{
    NSArray *recentDocURLs;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:@"/Users/jd/IUProjTemp/myApp.iuproject"]];
        recentDocURLs = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
        _recentDocs = [NSMutableArray array];
        for (NSURL *url in recentDocURLs) {
            [_recentDocs addObject:@{@"image": [NSImage imageNamed:@"start_reference"],
                                     @"name" : [url path]
                                     }];
        }
    }
    return self;
}

- (void)show{
    [_prevB setEnabled:NO];
    [_nextB setEnabled:YES];
    [_nextB setTarget:self];
    [_nextB setAction:@selector(pressNextB)];
}

- (void)pressNextB{
    LMAppDelegate *appDelegate = [NSApp delegate];
    NSUInteger index = [self.selectedIndexes firstIndex];
    NSDictionary *selectedDictionary = [_recentDocs objectAtIndex:index];
    [appDelegate loadDocument:selectedDictionary[@"name"]];
    [self.view.window close];
}


@end
