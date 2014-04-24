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

@property (weak) IBOutlet NSComboBox *ghostImageComboBox;
@property (weak) IBOutlet NSButton *ghostBtn;
@property (weak) IBOutlet NSTextField *ghostXTF;
@property (weak) IBOutlet NSTextField *ghostYTF;


@property (weak) IBOutlet NSButton *refreshBtn;
@property (weak) IBOutlet NSButton *leftInspectorBtn;
@property (weak) IBOutlet NSButton *rightInspectorBtn;
@property (weak) IBOutlet NSButton *borderBtn;
@property (weak) IBOutlet NSButton *mailBtn;

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
#pragma mark ghost
    [_ghostBtn bind:@"state" toObject:[NSUserDefaults standardUserDefaults] withKeyPath:@"showGhost" options:nil];
    
    [_ghostImageComboBox bind:NSEnabledBinding toObject:[NSUserDefaults standardUserDefaults]  withKeyPath:@"showGhost" options:IUBindingDictNotRaisesApplicable];
    [_ghostXTF bind:NSEnabledBinding toObject:[NSUserDefaults standardUserDefaults]  withKeyPath:@"showGhost" options:IUBindingDictNotRaisesApplicable];
    [_ghostYTF bind:NSEnabledBinding toObject:[NSUserDefaults standardUserDefaults]  withKeyPath:@"showGhost" options:IUBindingDictNotRaisesApplicable];
    
    [_ghostImageComboBox bind:NSContentBinding toObject:self withKeyPath:@"resourceManager.imageNames" options:IUBindingDictNotRaisesApplicable];
    [_ghostXTF bind:NSValueBinding toObject:self withKeyPath:@"document.ghostX" options:IUBindingDictNotRaisesApplicable];
    [_ghostYTF bind:NSValueBinding toObject:self withKeyPath:@"document.ghostY" options:IUBindingDictNotRaisesApplicable];
    
    [_ghostImageComboBox bind:NSValueBinding toObject:self withKeyPath:@"document.ghostImagePath" options:IUBindingDictNotRaisesApplicable];
    
#pragma mark bottom right tools
    [_borderBtn bind:@"state" toObject:[NSUserDefaults standardUserDefaults] withKeyPath:@"showBorder" options:nil];
    
    
}

- (void)setResourceManager:(IUResourceManager *)resourceManager{
    _resourceManager = resourceManager;
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
