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


- (void)setProject:(IUProject*)project{
    _project = project;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureChanged:) name:IUNotificationStructureChanged object:project];
    _pageLinkCB.delegate = self;
    for (IUPage *page in [project pageDocuments]) {
        [_pageLinkCB addItemWithObjectValue:page.name];
    }
}

- (CalledByNoti)structureChanged:(NSNotification*)noti{
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[IUNotificationStructureTarget] isKindOfClass:[IUPage class]]) {
        [_pageLinkCB removeAllItems];
        for (IUPage *page in [_project pageDocuments]) {
            [_pageLinkCB addItemWithObjectValue:page.name];
        }
    }
}

//called when combobox selection is changed by click
- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSString *link = [_pageLinkCB objectValueOfSelectedItem];
    [self setValue:link forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
}

//called when combobox selection is changed by string editing
- (void)controlTextDidChange:(NSNotification *)obj{
    NSString *link = [_pageLinkCB stringValue];
    [self setValue:link forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];}



@end
