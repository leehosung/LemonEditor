//
//  LMToolbarVC.m
//  IUEditor
//
//  Created by jd on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMBottomToolbarVC.h"
#import "LMWC.h"

@interface LMBottomToolbarVC ()


@property (weak) IBOutlet NSButton *refreshBtn;
@property (weak) IBOutlet NSButton *leftInspectorBtn;
@property (weak) IBOutlet NSButton *rightInspectorBtn;
@property (weak) IBOutlet NSButton *mailBtn;

@property (weak) IBOutlet NSButton *ghostBtn;
@property (weak) IBOutlet NSButton *borderBtn;

@end

@implementation LMBottomToolbarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [self.ghostBtn bind:@"state" toObject:[NSUserDefaults standardUserDefaults] withKeyPath:@"showGhost" options:nil];
    [self.borderBtn bind:@"state" toObject:[NSUserDefaults standardUserDefaults] withKeyPath:@"showBorder" options:nil];
}

- (IBAction)clickBorderBtn:(id)sender {
    BOOL showBorder = [[NSUserDefaults standardUserDefaults] boolForKey:@"showBorder"];
    [[NSUserDefaults standardUserDefaults] setBool:!showBorder forKey:@"showBorder"];
}
- (IBAction)clickGhostBtn:(id)sender {
    BOOL showGhost = [[NSUserDefaults standardUserDefaults] boolForKey:@"showGhost"];
    [[NSUserDefaults standardUserDefaults] setBool:!showGhost forKey:@"showGhost"];
}
- (IBAction)clickRefreshBtn:(id)sender {
    LMWC *lmWC = [NSApp mainWindow].windowController;
    [lmWC reloadCurrentDocument];
}

@end
