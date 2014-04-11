//
//  LMPropertyVC.m
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyFrameVC.h"
#import "IUBox.h"
#import "IUCSS.h"

@interface LMPropertyFrameVC ()
@property (weak) IBOutlet NSTextField *xTF;
@property (weak) IBOutlet NSTextField *yTF;
@property (weak) IBOutlet NSTextField *wTF;
@property (weak) IBOutlet NSTextField *hTF;
@property (weak) IBOutlet NSView *contentV;

@end

@implementation LMPropertyFrameVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib{
    NSString *tagCollectionKeyPath = @"controller.selection.css.assembledTagDictionary";
    [_xTF bind:@"value" toObject:self withKeyPath:[tagCollectionKeyPath stringByAppendingPathExtension:IUCSSTagX] options:nil];
    [_yTF bind:@"value" toObject:self withKeyPath:[tagCollectionKeyPath stringByAppendingPathExtension:IUCSSTagY] options:nil];
    [_wTF bind:@"value" toObject:self withKeyPath:[tagCollectionKeyPath stringByAppendingPathExtension:IUCSSTagWidth] options:nil];
    [_hTF bind:@"value" toObject:self withKeyPath:[tagCollectionKeyPath stringByAppendingPathExtension:IUCSSTagHeight] options:nil];
    
    [_contentV bind:@"hidden" toObject:self withKeyPath:@"controller.selection.hasFrame" options:@{NSValueTransformerNameBindingOption: @"NSNegateBoolean"}];
}




@end
