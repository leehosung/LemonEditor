//
//  LMStartWC.m
//  IUEditor
//
//  Created by jd on 4/25/14.
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
    _newVC.prevB = _prevB;
    _newVC.nextB = _nextB;
    [_newVC show];
    
    _recentVC.prevB = _prevB;
    _recentVC.nextB = _nextB;
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
            break;
        case 1:{
            [self removeCurrentView];
            [_mainV addSubview:_newVC.view];
            [_newVC show];
        }
            break;
        case 2:{
            [self removeCurrentView];
            [_mainV addSubview:_recentVC.view];
            [_recentVC show];
        }
            break;
    }
}

@end
