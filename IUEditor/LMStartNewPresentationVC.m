//
//  LMStartNewPresentationVC.m
//  IUEditor
//
//  Created by jw on 5/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartNewPresentationVC.h"

@interface LMStartNewPresentationVC ()

@end

@implementation LMStartNewPresentationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)show{
    assert(_nextB);
    [_nextB setTarget:self];
    [_nextB setEnabled:NO];
}
@end
