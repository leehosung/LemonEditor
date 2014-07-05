//
//  LMTutorialWC.m
//  IUEditor
//
//  Created by jw on 7/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMTutorialWC.h"

@interface LMTutorialWC ()
@property (weak) IBOutlet NSImageView *tutorialImageV;
@property (weak) IBOutlet NSButton *prevB;
@property (weak) IBOutlet NSButton *nextB;

@property   NSArray *tutorial, *tutorialEng, *tutorialKor;
@property   NSUInteger index;


@end

@implementation LMTutorialWC

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
       
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSString *tutorialImagePath = [[NSBundle mainBundle] pathForResource:@"tutorialList" ofType:@"plist"];
    NSDictionary *tutorialImageList = [NSDictionary dictionaryWithContentsOfFile:tutorialImagePath];
    
    _tutorialEng = [tutorialImageList objectForKey:@"English"];
    _tutorialKor = [tutorialImageList objectForKey:@"Korean"];
    
    _index = 0;
    [_tutorialImageV setImage:[NSImage imageNamed:@"Tutorial00.png"]];
}

- (void)setButtonOrder{
    [_prevB setTitle:@"Previous"];
    [_nextB setTitle:@"Next"];
}

- (void)setButtonLast{
    [_prevB setTitle:@"Previous"];
    [_nextB setTitle:@"Close"];
}
- (void) setButtonIntro{
    [_prevB setTitle:@"English"];
    [_nextB setTitle:@"한국어"];
}
- (IBAction)clickShowCheckButton:(NSButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.state forKey:@"iututorial"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)updateImageAndButton{
    if (_index== 0) {
        [self setButtonIntro];
    }
    else if(_index < _tutorial.count -1 ){
        [self setButtonOrder];
    }
    else{
        [self setButtonLast];
    }
    [_tutorialImageV setImage:[NSImage imageNamed:_tutorial[_index]]];
}
- (IBAction)pushPrevB:(id)sender {
    if (_index== 0) {
        //select English
        NSArray *array = _tutorialEng;
        _tutorial = array;
        _index++;
    }
    else{
        //prev tutorial
        _index--;
    }
    [self updateImageAndButton];
}
- (IBAction)pushNextB:(id)sender {
    if (_index == 0) {
        //select Korean
        NSArray *array = _tutorialKor;
        _tutorial = array;
        _index++;
    }
    else if (_index < _tutorial.count -1 && _index >0 ) {
        //next tutorial
        _index++;
    }
    else{
        [self.window close];
    }
    [self updateImageAndButton];

}




@end
