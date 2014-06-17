//
//  LMStartRecentVC.m
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartRecentVC.h"
#import "LMAppDelegate.h"
#import "IUProjectController.h"

@interface LMStartRecentVC ()

@end

@implementation LMStartRecentVC{
    NSArray *recentDocURLs;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _recentDocs = [NSMutableArray array];
        recentDocURLs = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
        NSUInteger i=0;
        for (NSURL *url in recentDocURLs){
            if (i++<8) {
                [_recentDocs addObject:[@{@"image": [NSImage imageNamed:@"new_default"],
                                          @"name" : [url lastPathComponent],
                                          @"path": [url path],
                                          //@"selection": @(NO),
                                          } mutableCopy]];
            }
        }
    }
    return self;
}

- (void)awakeFromNib{
    [_recentAC setContent:_recentDocs];
    
}

- (void)show{
    [_prevB setEnabled:NO];
    [_nextB setEnabled:YES];
    [_nextB setTarget:self];
    [_nextB setAction:@selector(pressNextB)];
}

- (void)pressNextB{
    NSUInteger index = [self.selectedIndexes firstIndex];
    NSDictionary *selectedDictionary = [_recentDocs objectAtIndex:index];
    NSString *path = selectedDictionary[@"path"];
    [(IUProjectController *)[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES completionHandler:nil];
    
    [self.view.window close];
}

-(NSMutableDictionary *)projectDictWithPath: (NSString*)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *err;
    NSMutableDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err] ;
    if (err) {
        [JDLogUtil log:@"load project" err:err];
        assert(0);
    }
    return contentDict;

}

- (void)setSelectedIndexes:(NSIndexSet *)selectedIndexes{
    _selectedIndexes = selectedIndexes;
    for (NSMutableDictionary *dict in _recentDocs) {
        dict[@"selection"] = @(NO);
    }
    NSMutableDictionary *selected = [_recentDocs objectAtIndex:[selectedIndexes firstIndex]];
    selected[@"selection"] = @(YES);
    
//    NSLog([selectedIndexes description]);
    
}
 
@end
