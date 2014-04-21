//
//  LMPropertyBGColorVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyBGColorVC.h"

@interface LMPropertyBGColorVC ()

@property (weak) IBOutlet NSColorWell *bgColorWell;

@end

@implementation LMPropertyBGColorVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (NSString*)CSSBindingPath:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}

- (void)awakeFromNib{
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    [NSColor setIgnoresAlpha:NO];

    [_bgColorWell bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagBGColor] options:nil];
}

- (void)makeClearColor:(id)sender{
    [self setValue:nil forKeyPath:[self CSSBindingPath:IUCSSTagBGColor]];
}

@end
