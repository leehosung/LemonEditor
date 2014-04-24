//
//  LMPropertyTextVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyTextVC.h"

@interface LMPropertyTextVC ()

@property (weak) IBOutlet NSComboBox *fontB;
@property (weak) IBOutlet NSTextField *fontSizeB;
@property (weak) IBOutlet NSColorWell *fontColorWell;
@property NSArray *fonts;

@property (weak) IBOutlet NSSegmentedControl *fontStyleB;
@property (weak) IBOutlet NSSegmentedControl *textAlignB;
@property (weak) IBOutlet NSComboBox *lineHeightB;

@end

@implementation LMPropertyTextVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fonts = @[@"Georgia", @"Times New Roman", @"Arial" ];
    }
    return self;
}

- (NSString*)CSSBindingPath:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}

- (IBAction)fontDecoBPressed:(id)sender {

    BOOL value;
    value = [sender isSelectedForSegment:0];
    [self setValue:@(value) forKeyPath:[self CSSBindingPath:IUCSSTagFontWeight]];
    
    value = [sender isSelectedForSegment:1];
    [self setValue:@(value) forKeyPath:[self CSSBindingPath:IUCSSTagFontStyle]];
    
    value = [sender isSelectedForSegment:2];
    [self setValue:@(value) forKeyPath:[self CSSBindingPath:IUCSSTagTextDecoration]];
    
}

- (IBAction)textAligneBPressed:(id)sender {
    
    NSString *textalign;
    if([sender isSelectedForSegment:0]){
        textalign= @"left";    }
    if([sender isSelectedForSegment:1]){
        textalign=@"center";    }
    if([sender isSelectedForSegment:2]){
        textalign=@"right";    }
    if([sender isSelectedForSegment:3]){
        textalign= @"stretch";    }
    
    [self setValue:textalign forKeyPath:[self CSSBindingPath:IUCSSTagTextAlign]];
}


-(void)awakeFromNib{
    
    [_fontB bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagFontName] options:nil];
    [_fontB bind:@"contentValues" toObject:self withKeyPath:@"fonts" options:nil];
    [_fontSizeB bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagFontSize] options:nil];
    [_fontColorWell bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagFontColor] options:nil];
    [_lineHeightB bind:@"value" toObject:self withKeyPath:[self CSSBindingPath:IUCSSTagLineHeight] options:nil];
 }

@end
