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
    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:0 context:@"selection"];
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

- (void)setController:(IUController *)controller{
    NSAssert(_controller == nil, @"duplicated initialize" );
    _controller = controller;
    [self addObserver:self forKeyPath:[controller keyPathFromControllerToProperty:@"link"] options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    id value = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
    if (value == NSNoSelectionMarker || value == nil) {
        [_pageLinkCB setStringValue:@""];
    }
    else if (value == NSMultipleValuesMarker) {
        [_pageLinkCB setStringValue:@" - Multiple Value"];
    }
    else {
        [_pageLinkCB setStringValue:value];
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
    [self setValue:link forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
}
- (void)selectionContextDidChange:(NSDictionary *)change{
    id currentLink = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
    
    if(currentLink == nil || currentLink == NSNoSelectionMarker){
        [_pageLinkCB setStringValue:@""];
    }
    else if(currentLink){
        [_pageLinkCB setStringValue:currentLink];
    }
}



@end
