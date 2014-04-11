//
//  LMPropertyFontVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 11..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyFontVC.h"

@interface LMPropertyFontVC ()

@end

@implementation LMPropertyFontVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
}

- (void)setEnable:(BOOL)enable{
    [self.fontName setEnabled:enable];
    [self.fontSize setEnabled:enable];
    [self.fontColor setEnabled:enable];
    [self.fontTraits setEnabled:enable];
    [self.fontAlignment setEnabled:enable];
    [self.fontLineHeight setEnabled:enable];
}

-(void)currentFontStateUpdate{
    
}

-(void)currentFont{
    
}


- (IBAction)clickFontNameBtn:(id)sender {

}

- (IBAction)clickFontSizeBtn:(id)sender {
}

- (IBAction)clickFontColor:(id)sender {
}

- (IBAction)clickFontTraitsControl:(id)sender {
    /*
    for(int i=0; i<3; i++){
        BOOL trait =  [self.fontTraits isSelectedForSegment:i];
        self.fontManager addFontTrait:
    }
     */
}

- (IBAction)clickFontAlignControl:(id)sender {
}

- (IBAction)clickLineHeight:(id)sender {
}

- (IBAction)clickTestBtn:(id)sender {
}
@end
