//
//  LMTopToolbarVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMTopToolbarVC.h"
#import "IUDocumentNode.h"

@interface LMTopToolbarVC ()

@end

@implementation LMTopToolbarVC

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
