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
@property (weak) IBOutlet NSPopUpButton *pageLinkPopupButton;
@property (weak) IBOutlet NSPopUpButton *divLinkPB; //not use for alpha 0.2 version
@property (weak) IBOutlet NSButton *urlCheckButton;
@property (weak) IBOutlet NSTextField *urlTF;

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
    _urlTF.delegate = self;
    [_divLinkPB setEnabled:NO];
    
    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:0 context:@""];
}


- (void)setProject:(IUProject*)project{
    _project = project;
    [self updateLinkPopupButtonItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureChanged:) name:IUNotificationStructureDidChange object:project];
}


- (CalledByNoti)structureChanged:(NSNotification*)noti{
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[IUNotificationStructureChangedIU] isKindOfClass:[IUPage class]]) {
        [self updateLinkPopupButtonItems];
    }
}
- (void)updateLinkPopupButtonItems{
    [_pageLinkPopupButton removeAllItems];
    [_pageLinkPopupButton addItemWithTitle:@"None"];
    for (IUPage *page in [_project pageDocuments]) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:page.name action:nil keyEquivalent:@""];
        item.representedObject = page;
        [[_pageLinkPopupButton menu] addItem:item];
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
        [_urlCheckButton setState:0];
#pragma mark - set link
        id value = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
        
        if (value == NSNoSelectionMarker || value == nil) {
            [_pageLinkPopupButton selectItemWithTitle:@"None"];
            [_urlTF setStringValue:@"Empty"];

        }
        else if (value == NSMultipleValuesMarker) {
            [_pageLinkPopupButton selectItemWithTitle:@"None"];
            [_urlTF setStringValue:@"multiple"];
        }
        else {
            if([value isKindOfClass:[IUBox class]]){
                [_pageLinkPopupButton selectItemWithTitle:((IUBox *)value).name];
                [_urlCheckButton setState:0];
                [_urlTF setStringValue:@""];
                [self updateDivLink:value];
            }
            else{
                [_urlCheckButton setState:1];
                [_urlTF setStringValue:value];
                [_pageLinkPopupButton selectItemWithTitle:@"None"];
            }
        }
        [self updateLinkEnableState];
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

- (void)updateLinkEnableState{
    if([_urlCheckButton state] == 0){
        [_pageLinkPopupButton setEnabled:YES];
        [_urlTF setEnabled:NO];
    }
    else{
        [_pageLinkPopupButton setEnabled:NO];
        [_urlTF setEnabled:YES];
    }
}

#pragma mark - IBAction

- (IBAction)clickEnableURLCheckButton:(id)sender {
    [self updateLinkEnableState];
}

- (IBAction)clickLinkPopupButton:(id)sender {
    NSString *link = [[_pageLinkPopupButton selectedItem] title];
    if([link isEqualToString:@"None"]){
        return;
    }
    if(_project){
        IUBox *box = [_project.identifierManager IUWithIdentifier:link];
        if(box){
            [self setValue:box forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
            [self updateDivLink:(IUPage *)box];
        }
        
    }
    
}


- (void)controlTextDidChange:(NSNotification *)obj{
    NSTextField *textField = obj.object;
    if([textField isEqualTo:_urlTF]){
        NSString *link = [_urlTF stringValue];
        if(link && link.length > 0){
            [self setValue:link forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
        }
        else if(link.length == 0){
            [self setValue:nil forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
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
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:box.name action:nil keyEquivalent:@""];
        item.representedObject = box;
        [[_divLinkPB menu] addItem:item];
    }
    
}
- (IBAction)clickDivLinkPopupBtn:(id)sender {
    
    if([[_divLinkPB selectedItem] isEqualTo:[_divLinkPB itemAtIndex:0]]){
        [self setValue:nil forKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"]];
        return;
    }
    
    NSString *link = [[_divLinkPB selectedItem] title];
    
    if(_project){
        IUBox *box = [sender selectedItem].representedObject;
        if(box){
            [self setValue:box forKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"]];
        }
    }
 
}

@end
