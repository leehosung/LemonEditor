//
//  LMCloseWC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 27..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMCloseWC.h"

@interface LMCloseWC ()
@property (weak) IBOutlet NSTextField *titleTF;
@end

@implementation LMCloseWC{

}

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [_titleTF bind:NSValueBinding toObject:self withKeyPath:@"projectName" options:IUBindingDictNotRaisesApplicable];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)setProjectName:(NSString *)projectName{
    _projectName = [NSString stringWithFormat:@"Do you want to save the change made to the project \"%@\"?", projectName];
}

- (IBAction)clickDontSaveBtn:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];

}
- (IBAction)clickSaveBtn:(id)sender {
    [[[self.window.sheetParent windowController] document] saveDocument:self];
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}
- (IBAction)clickCancelBtn:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

@end
