//
//  LMPropertyIUBoxVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUBoxVC.h"

@interface LMPropertyIUBoxVC ()

@property (weak) IBOutlet NSComboBox *linkCB;

@end

@implementation LMPropertyIUBoxVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_linkCB bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"link"] options:nil];

}



@end
