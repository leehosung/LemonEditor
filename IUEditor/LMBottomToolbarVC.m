//
//  LMToolbarVC.m
//  IUEditor
//
//  Created by jd on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMBottomToolbarVC.h"
#import "LMTutorialManager.h"
#import "LMHelpPopover.h"
#import "LMWC.h"

@interface LMBottomToolbarVC ()

@property (weak) IBOutlet NSComboBox *ghostImageComboBox;
@property (weak) IBOutlet NSButton *ghostBtn;
@property (weak) IBOutlet NSTextField *ghostXTF;
@property (weak) IBOutlet NSTextField *ghostYTF;
@property (weak) IBOutlet NSSlider *opacitySlider;


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
    
    _ghostImageComboBox.delegate = self;
    [_ghostBtn bind:@"state" toObject:[NSUserDefaults standardUserDefaults] withKeyPath:@"showGhost" options:nil];
    
    [_ghostImageComboBox bind:NSEnabledBinding toObject:[NSUserDefaults standardUserDefaults]  withKeyPath:@"showGhost" options:IUBindingDictNotRaisesApplicable];
    [_ghostXTF bind:NSEnabledBinding toObject:[NSUserDefaults standardUserDefaults]  withKeyPath:@"showGhost" options:IUBindingDictNotRaisesApplicable];
    [_ghostYTF bind:NSEnabledBinding toObject:[NSUserDefaults standardUserDefaults]  withKeyPath:@"showGhost" options:IUBindingDictNotRaisesApplicable];
    
    [_ghostImageComboBox bind:NSContentBinding toObject:self withKeyPath:@"resourceManager.imageFiles" options:IUBindingDictNotRaisesApplicable];
    [_ghostXTF bind:NSValueBinding toObject:self withKeyPath:@"sheet.ghostX" options:IUBindingDictNotRaisesApplicable];
    [_ghostYTF bind:NSValueBinding toObject:self withKeyPath:@"sheet.ghostY" options:IUBindingDictNotRaisesApplicable];
    [_opacitySlider bind:NSValueBinding toObject:self withKeyPath:@"sheet.ghostOpacity" options:IUBindingDictNotRaisesApplicable];
    
    
#pragma mark bottom right tools
    [_borderBtn bind:@"state" toObject:[NSUserDefaults standardUserDefaults] withKeyPath:@"showBorder" options:nil];
    [self addObserver:self forKeyPath:@"sheet.ghostImageName" options:0 context:nil];
    _ghostImageComboBox.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showLeftInspector"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"showLeftInspector"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showRightInspector"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"showRightInspector"];
    }
    
    [_leftInspectorBtn bind:@"state" toObject:[NSUserDefaults standardUserDefaults] withKeyPath:@"showLeftInspector" options:IUBindingDictNotRaisesApplicable];
    [_rightInspectorBtn bind:@"state" toObject:[NSUserDefaults standardUserDefaults]  withKeyPath:@"showRightInspector" options:IUBindingDictNotRaisesApplicable];
}
-(void) dealloc{
    //release 시점 확인용
    assert(0);
//    [self removeObserver:self forKeyPath:@"sheet.ghostImageName"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"sheet.ghostImageName"]){
        if ([[_ghostImageComboBox stringValue] isEqualToString:_sheet.ghostImageName] == NO) {
            if (_sheet.ghostImageName == nil) {
                [_ghostImageComboBox setStringValue:@""];
            }
            else {
                [_ghostImageComboBox setStringValue:_sheet.ghostImageName];
            }
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSString *fileName = [_ghostImageComboBox objectValueOfSelectedItem];
    self.sheet.ghostImageName = fileName;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    NSString *fileName = [control stringValue];
    self.sheet.ghostImageName = fileName;
    return YES;
}



- (void)setResourceManager:(IUResourceManager *)resourceManager{
    _resourceManager = resourceManager;
}

- (IBAction)clickBorderBtn:(id)sender {
    BOOL showBorder = [[NSUserDefaults standardUserDefaults] boolForKey:@"showBorder"];
    [[NSUserDefaults standardUserDefaults] setBool:!showBorder forKey:@"showBorder"];
}
- (IBAction)clickGhostBtn:(NSButton*)sender {
    //show tutorial if needed
    if ([LMTutorialManager shouldShowTutorial:@"Ghost"]) {
        [[LMHelpPopover sharedHelpPopover] setType:LMPopoverTypeTextAndVideo];
        [[LMHelpPopover sharedHelpPopover] setVideoName:@"movie.mp4" title:@"How to use Ghose" rtfFileName:@"ghost.rtf"];
        [[LMHelpPopover sharedHelpPopover] showRelativeToRect:sender.frame ofView:self.view preferredEdge:NSMaxYEdge];
    }
    BOOL showGhost = [[NSUserDefaults standardUserDefaults] boolForKey:@"showGhost"];
    [[NSUserDefaults standardUserDefaults] setBool:!showGhost forKey:@"showGhost"];
}
- (IBAction)clickRefreshBtn:(id)sender {
    LMWC *lmWC = [NSApp mainWindow].windowController;
    [lmWC reloadCurrentDocument];
}

#pragma mark -
- (IBAction)toggleLeftInspector:(id)sender {
    BOOL showLeftInspector = [[NSUserDefaults standardUserDefaults] boolForKey:@"showLeftInspector"];
    [[NSUserDefaults standardUserDefaults] setBool:!showLeftInspector forKey:@"showLeftInspector"];
}
- (IBAction)toggleRightInspector:(id)sender {
    BOOL showRightInspector = [[NSUserDefaults standardUserDefaults] boolForKey:@"showRightInspector"];
    [[NSUserDefaults standardUserDefaults] setBool:!showRightInspector forKey:@"showRightInspector"];
}

#pragma mark - mail
- (IBAction)clickEmailBtn:(id)sender {
    NSString *url = [IUEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[NSWorkspace sharedWorkspace]  openURL:[NSURL URLWithString:url]];
}


@end
