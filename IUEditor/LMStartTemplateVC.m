//
//  LMStartTemplateVC.m
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartTemplateVC.h"
#import "JDFileUtil.h"
#import "IUProjectController.h"
#import "LMAppDelegate.h"
#import "LMWC.h"

@interface LMStartTemplateVC ()

@end

@implementation LMStartTemplateVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"sampleTemplate" ofType:@"plist"];
    NSArray *templateList = [NSArray arrayWithContentsOfFile:templatePath];
    NSMutableArray *tempList = [[NSMutableArray alloc] initWithArray:templateList];
    
    [_templateAC setContent:tempList];
    
    //image 연결하자
    
    [self.templateAC setSelectionIndex:0];
}

-(void)show{
    assert(_nextB);
    [_prevB setEnabled:NO];
    [_nextB setTarget:self];
    [_nextB setEnabled:YES];
    [_nextB setAction:@selector(pressNextB)];
}


-(void)pressNextB{
    if(self.templateAC.selectedObjects.count <=0){
     return;
    }
    
    NSArray *selectedProject = self.templateAC.selectedObjects;
    NSDictionary *dict = selectedProject[0];
    NSString *selectedName = dict[@"name"];
    NSString *selectedFile = dict[@"projectPackageFile"];
    
    NSURL *url = [[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Directory"];
    if (url == nil) {
        return;
    }
    
    NSURL *targetURL = [url URLByAppendingPathComponent:selectedName];
    NSString *targetPath = [targetURL path];
    [[JDFileUtil util] unzipResource:selectedFile toDirectory:targetPath createDirectory:YES];
    
    NSURL *openURL = [[[NSURL fileURLWithPath:targetPath] URLByAppendingPathComponent:selectedName ] URLByAppendingPathExtension:@"iu"];
    [(IUProjectController *)[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:openURL display:YES completionHandler:nil];
    [self.view.window close];

 }


    
    


@end
