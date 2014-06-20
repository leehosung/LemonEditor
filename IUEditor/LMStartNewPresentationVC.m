//
//  LMStartNewPresentationVC.m
//  IUEditor
//
//  Created by jw on 5/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartNewPresentationVC.h"
#import "LMStartNewVC.h"
@interface LMStartNewPresentationVC ()

@end

@implementation LMStartNewPresentationVC

- (void)show{
    assert(_parentVC);
    assert(_nextB);
    [_nextB setTarget:self];
    [_nextB setEnabled:NO];
    
    [_prevB setTarget:self];
    [_prevB setEnabled:YES];
    [_prevB setAction:@selector(performPrev)];
}

- (void)performPrev{
    assert(_parentVC);
    [_parentVC show];
}

@end
