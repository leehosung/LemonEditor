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

static LMStartWC *gStartWindow = nil;

@interface LMStartWC ()
@property (weak) IBOutlet NSTabView *tabView;

@property (weak) IBOutlet NSView *templateV;
@property (weak) IBOutlet NSView *projectV;
@property (weak) IBOutlet NSView *recentV;


@property (weak) IBOutlet NSMatrix *menuSelectB;
@end

@implementation LMStartWC{
    LMStartNewVC    *_newVC;
    LMStartRecentVC *_recentVC;
    LMStartTemplateVC *_templateVC;
}

+ (LMStartWC *)sharedStartWindow{
    if(gStartWindow == nil){
        gStartWindow = [[LMStartWC alloc] initWithWindowNibName:@"LMStartWC"];
    }
    return gStartWindow;
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
    
    [_templateV addSubviewFullFrame:_templateVC.view];
    [_recentV addSubviewFullFrame:_recentVC.view];
    [_projectV addSubviewFullFrame:_newVC.view];
    
}

- (IBAction)pressMenuSelectB:(id)sender {
    NSUInteger selectedIndex = [_menuSelectB selectedColumn];
    [_tabView selectTabViewItemAtIndex:selectedIndex];
}
@end
