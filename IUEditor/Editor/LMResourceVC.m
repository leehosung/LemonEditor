//
//  LMResourceVC.m
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMResourceVC.h"
#import "IUResourceNode.h"

@interface LMResourceVC ()
@property NSArray *contents;
@end

@implementation LMResourceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)setNode:(IUResourceGroupNode *)node{
    _node = node;
}


@end
