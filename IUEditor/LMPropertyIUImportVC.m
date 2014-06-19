//
//  LMPropertyIURenderVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUImportVC.h"
#import "IUSheetGroup.h"
#import "IUClass.h"
#import "IUImport.h"
#import "IUProject.h"

@interface LMPropertyIUImportVC ()
@property (weak) IBOutlet NSPopUpButton *prototypeB;
@end

@implementation LMPropertyIUImportVC {
    IUProject *_project;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}


- (void)structureChanged:(NSNotification*)noti{
    [_prototypeB removeAllItems];
    [_prototypeB addItemWithTitle:@"None"];
    [_prototypeB addItemsWithTitles:[[_project classDocuments] valueForKey:@"name"]];
}

- (void)setProject:(IUProject*)project{
    _project = project;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureChanged:) name:IUNotificationStructureChanged object:project];
    [self structureChanged:nil];
}

- (void)setController:(IUController *)controller{
    _controller = controller;
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToProperty:@"prototypeClass"] options:0 context:nil];
}

- (void)dealloc{
    //release 시점 확인용
    assert(0);
}

- (IBAction)performPrototypeChange:(NSPopUpButton *)sender {
    IUClass *class = [[_project classDocuments] objectWithKey:@"name" value:sender.selectedItem.title];
    NSArray *selectedIUs = _controller.selectedObjects;
    for (IUImport *iu in selectedIUs) {
        assert([iu isKindOfClass:[IUImport class]]);
        iu.prototypeClass = class;
    }
}



@end