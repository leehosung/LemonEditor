//
//  LMStartWC.m
//  IUEditor
//
//  Created by jd on 4/25/14.s
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartWC.h"
#import "LMAppDelegate.h"

#import "LMStartNewVC.h"
#import "LMStartRecentVC.h"
#import "LMStartTemplateVC.h"

@interface LMStartWC ()
@property (weak) IBOutlet NSView *mainV;
@property (weak) IBOutlet NSMatrix *menuSelectB;
@property (weak) IBOutlet NSButton *nextB;
@property (weak) IBOutlet NSButton *prevB;
@end

@implementation LMStartWC{
    LMStartNewVC    *_newVC;
    LMStartRecentVC *_recentVC;
    LMStartTemplateVC *_templateVC;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _newVC = [[LMStartNewVC alloc] initWithNibName:@"LMStartNewVC" bundle:nil];
        _recentVC = [[LMStartRecentVC alloc] initWithNibName:@"LMStartRecentVC" bundle:nil];
        _templateVC = [[LMStartTemplateVC alloc] initWithNibName:[LMStartTemplateVC class].className bundle:nil];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib{
    [_mainV addSubview:_newVC.view];
    [_prevB setTarget:_newVC];
    [_nextB setTarget:_newVC];
    _newVC.prevB = _prevB;
    _newVC.nextB = _nextB;
    [_nextB setAction:@selector(pressNextB)];
    [_prevB setAction:@selector(pressPrevB)];
}

- (void)removeCurrentView{
    for(NSView *view in _mainV.subviews){
        [view removeFromSuperview];
    }
}

- (IBAction)pressMenuSelectB:(id)sender {
    NSUInteger selectedIndex = [_menuSelectB selectedColumn];
    switch (selectedIndex) {
        case 0:
            [self removeCurrentView];
            [_mainV addSubviewFullFrame:_templateVC.view];
            [_prevB setTarget:_templateVC];
            [_prevB setEnabled:NO];
            [_prevB setHidden:YES];
            [_nextB setTarget:_templateVC];
            break;
        case 1:{
            [self removeCurrentView];
            [_mainV addSubview:_newVC.view];
            [_prevB setTarget:_newVC];
            [_nextB setTarget:_newVC];
            }
            break;
        case 2:{
            [self removeCurrentView];
            [_mainV addSubview:_recentVC.view];
            [_prevB setTarget:_recentVC];
            [_prevB setEnabled:NO];
            [_nextB setTarget:_recentVC];

        }
            break;
    }
}
- (void)pressNextB{
    assert(0);
}
- (void)pressPrevB{
    assert(0);
}
@end
