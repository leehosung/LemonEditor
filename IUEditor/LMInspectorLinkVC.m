//
//  LMPropertyIUBoxVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMInspectorLinkVC.h"
#import "IUSheetGroup.h"
#import "IUSheet.h"
#import "IUPage.h"
#import "IUProject.h"

@interface LMInspectorLinkVC ()
@property (weak) IBOutlet NSComboBox *pageLinkCB;
@property (weak) IBOutlet NSPopUpButton *divLinkPB; //not use for alpha 0.2 version

@end

@implementation LMInspectorLinkVC{
    IUProject *_project;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self loadView];

    }
    return self;
}

- (void)awakeFromNib{
    [_divLinkPB setEnabled:NO];
    
    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:0 context:@""];
}


- (void)setProject:(IUProject*)project{
    _project = project;
    [self updateLinkComboBoxItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureChanged:) name:IUNotificationStructureDidChange object:project];
}


- (CalledByNoti)structureChanged:(NSNotification*)noti{
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[IUNotificationStructureChangedIU] isKindOfClass:[IUPage class]]) {
        [self updateLinkComboBoxItems];
    }
}
- (void)updateLinkComboBoxItems{
    [_pageLinkCB removeAllItems];
    for (IUPage *page in [_project pageDocuments]) {
        [_pageLinkCB addItemWithObjectValue:[page.name copy]];
    }

}

- (void)setController:(IUController *)controller{
    NSAssert(_controller == nil, @"duplicated initialize" );
    _controller = controller;
    [self addObserver:self forKeyPath:[controller keyPathFromControllerToProperty:@"link"] options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"controller.selectedObjects"]){
        
        [_divLinkPB setEnabled:NO];
#pragma mark - set link
        id value = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
        [[_pageLinkCB cell] setPlaceholderString:@""];
        
        if (value == NSNoSelectionMarker || value == nil) {
            [_pageLinkCB setStringValue:@""];
        }
        else if (value == NSMultipleValuesMarker) {
            [[_pageLinkCB cell] setPlaceholderString:[NSString stringWithValueMarker:value]];
            [_pageLinkCB setStringValue:@""];
        }
        else {
            if([value isKindOfClass:[IUBox class]]){
                [_pageLinkCB setStringValue:((IUBox *)value).name];
                [self updateDivLink:value];
            }
            else{
                [_pageLinkCB setStringValue:value];
            }
        }
#pragma mark - set div link
        value = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"]];

        if([value isKindOfClass:[IUBox class]]){
            [_divLinkPB selectItemWithTitle:((IUBox *)value).name];
        }
        else{
            [_divLinkPB selectItemAtIndex:0];
        }
    }
}

- (IBAction)clickLinkComboBox:(id)sender {
    NSString *link = [_pageLinkCB stringValue];
    if(_project){
        IUBox *box = [_project.identifierManager IUWithIdentifier:link];
        if(box){
            [self setValue:box forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
            [self updateDivLink:(IUPage *)box];
        }
        else{
            [self setValue:link forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
        }
    }
    
}

#pragma mark - div link

- (void)updateDivLink:(IUPage *)page{
    assert([page isKindOfClass:[IUPage class]]);
    [_divLinkPB setEnabled:YES];
    [_divLinkPB removeAllItems];
    [_divLinkPB addItemWithTitle:@"None"];
    for(IUBox *box in page.allChildren){
        [_divLinkPB addItemWithTitle:box.name];
    }
    
    
}
- (IBAction)clickDivLinkPopupBtn:(id)sender {
    
    if([[_divLinkPB selectedItem] isEqualTo:[_divLinkPB itemAtIndex:0]]){
        [self setValue:nil forKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"]];
        return;
    }
    
    NSString *link = [[_divLinkPB selectedItem] title];
    
    if(_project){
        IUBox *box = [_project.identifierManager IUWithIdentifier:link];
        if(box){
            [self setValue:box forKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"]];
        }
    }
 
}

@end
