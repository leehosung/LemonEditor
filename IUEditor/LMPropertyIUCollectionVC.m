//
//  LMPropertyIUCollectionVC.m
//  IUEditor
//
//  Created by jd on 4/29/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyIUCollectionVC.h"

@interface LMPropertyIUCollectionVC ()
@property (weak) IBOutlet NSTextField *variableTF;
@end

@implementation LMPropertyIUCollectionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_variableTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"collectionVariable"] options:nil];
}
@end
