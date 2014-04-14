//
//  LMToolbarVC.m
//  IUEditor
//
//  Created by jd on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMToolbarVC.h"
#import "IUDocumentNode.h"

@interface LMToolbarVC ()

@end

@implementation LMToolbarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)showBPressed:(id)sender {
    IUProject *project = _documentController.project;
    [project build:nil];
    IUDocumentNode *firstNode = [[project pageDocumentNodes] firstObject];
    NSString *firstPath = [project.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.html",project.buildDirectoryName, firstNode.name] ];
    
    [[NSWorkspace sharedWorkspace] openFile:firstPath];
}

@end
