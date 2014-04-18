//
//  LMPropertyTextVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyTextVC.h"

@interface LMPropertyTextVC ()

@end

@implementation LMPropertyTextVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)setController:(IUController *)controller{
    assert(_controller == nil); // should called only once
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selectedTextRange" options:0 context:nil];
}

- (void)selectedTextRangeDidChange:(NSDictionary*)change{
    
}

@end
