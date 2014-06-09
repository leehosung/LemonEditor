//
//  LMStartTemplateVC.m
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartTemplateVC.h"
#import "JDFileUtil.h"
#import "IUProject.h"
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
 //   NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"sampleTemplate" ofType:@"plist"];
 //   NSArray *templateList = [NSArray arrayWithContentsOfFile:templatePath];
    
    
    
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
    
//    NSArray *selectedProject = self.templateAC.selectedObjects;
 }
 
    
    
    


@end
