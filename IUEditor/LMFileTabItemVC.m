//
//  LMFileTabVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMFileTabItemVC.h"
#import "LMTopToolbarVC.h"

@implementation LMTabBox


@end

@interface LMFileTabItemVC (){
}


@end

@implementation LMFileTabItemVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib{
    [_fileNameBtn bind:@"title" toObject:self withKeyPath:@"sheet.name" options:IUBindingDictNotRaisesApplicable];
}


- (IBAction)clickSelectFile:(id)sender {
    [self.delegate selectTab:_sheet];
}
- (IBAction)clickCloseFile:(id)sender {
    [self.delegate closeTab:self sender:self];
}

- (void)setDeselectColor{
    [_fileBox setFillColor:[NSColor secondarySelectedControlColor]];
}

- (void)setSelectColor{
    [_fileBox setFillColor:[NSColor whiteColor]];
}

@end
