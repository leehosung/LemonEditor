//
//  LMPropertyIUFormVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyPGFormVC.h"
#import "IUPage.h"
#import "IUProject.h"
#import "IUBox.h"
#import "PGForm.h"

@interface LMPropertyPGFormVC ()
@property (weak) IBOutlet NSComboBox *submitPageComboBox;

@end

@implementation LMPropertyPGFormVC{
    IUProject *_project;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self loadView];
    }
    return self;
}

- (void)awakeFromNib{
    _submitPageComboBox.delegate = self;
    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:0 context:@""];

}

- (void)performFocus:(NSNotification *)noti{
    [self.view.window makeFirstResponder:_submitPageComboBox];
}

- (void)setProject:(IUProject *)project{
    _project = project;
    [self updatePageComboBoxContents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureChanged:) name:IUNotificationStructureDidChange object:project];

}

- (CalledByNoti)structureChanged:(NSNotification*)noti{
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[IUNotificationStructureChangedIU] isKindOfClass:[IUPage class]]) {
        [self updatePageComboBoxContents];
    }
}

- (void)updatePageComboBoxContents{
    [_submitPageComboBox removeAllItems];
    for (IUPage *page in [_project pageDocuments]) {
        [_submitPageComboBox addItemWithObjectValue:[page.name copy]];
    }
}

- (void)controlTextDidChange:(NSNotification *)obj{
    NSComboBox *currentComboBox = obj.object;
    if([currentComboBox isEqualTo:_submitPageComboBox]){
        [self updatePageComboBox:[_submitPageComboBox stringValue]];
    }
}


- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSComboBox *currentComboBox = notification.object;
    if([currentComboBox isEqualTo:_submitPageComboBox]){
        [self updatePageComboBox:[_submitPageComboBox objectValueOfSelectedItem]];
    }
}

- (void)updatePageComboBox:(NSString *)target {
    
    if(_project){
        IUBox *box = [_project.identifierManager IUWithIdentifier:target];
        if(box){
            [self setValue:box forKeyPath:[_controller keyPathFromControllerToProperty:@"target"]];
        }
        else{
            [self setValue:target forKeyPath:[_controller keyPathFromControllerToProperty:@"target"]];
        }
    }
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"controller.selectedObjects"]){
        
#pragma mark - set target
        id value = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"target"]];
        [[_submitPageComboBox cell] setPlaceholderString:@""];
        
        if (value == NSNoSelectionMarker || value == nil) {
            [_submitPageComboBox setStringValue:@""];
        }
        else if (value == NSMultipleValuesMarker) {
            [[_submitPageComboBox cell] setPlaceholderString:[NSString stringWithValueMarker:value]];
            [_submitPageComboBox setStringValue:@""];
        }
        else {
            if([value isKindOfClass:[IUBox class]]){
                [_submitPageComboBox setStringValue:((IUBox *)value).name];
            }
            else{
                [_submitPageComboBox setStringValue:value];
            }
        }

    }
}
@end
