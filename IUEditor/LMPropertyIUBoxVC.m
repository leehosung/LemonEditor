//
//  LMPropertyIUBoxVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUBoxVC.h"
#import "IUDocumentGroup.h"
#import "IUDocument.h"

@interface LMPropertyIUBoxVC ()

@property (strong) IBOutlet NSArrayController *pageDocumentAC;
@property (strong) IBOutlet NSArrayController *divAC;

@property (weak) IBOutlet NSComboBox *linkCB;
@property (weak) IBOutlet NSPopUpButton *divPopupBtn;
@property (weak) IBOutlet NSTextField *pgVisibleTF;


@end

@implementation LMPropertyIUBoxVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_pageDocumentAC bind:NSContentArrayBinding toObject:self withKeyPath:@"pageDocumentNodes" options:nil];
    [_linkCB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"link"] options:IUBindingDictNotRaisesApplicable];
    [_divPopupBtn bind:NSSelectedValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"] options:IUBindingDictNotRaisesApplicable];
    [_pgVisibleTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"pgVisibleCondition"] options:IUBindingDictNotRaisesApplicable];

    [self.controller addObserver:self forKeyPath:@"selection" options:NSKeyValueObservingOptionInitial context:nil];

}

- (BOOL)isPage:(NSString *)link{
    assert(0);
    /*
    for(IUDocumentGroup *node in _pageDocumentNodes){
        if([node.name isEqualToString:link]){
            return YES;
        }
    }
     */
    return NO;
}
- (IBAction)clickLinkComboBox:(id)sender {
    [self setDivLink];
}

- (void)selectionDidChange:(NSDictionary *)change{
    [self setDivLink];
}

- (void)setDivLink{
    return;
    assert(0);
    /*
    NSString *link = [[_linkCB selectedCell] stringValue];
    [_divAC setContent:nil];

    if([self isPage:link]){
        IUDocumentGroup *node = [[_pageDocumentAC selectedObjects] objectAtIndex:0];
        IUDocument *document = node.document;
        [_divAC addObjects:document.allChildren];
        [_divPopupBtn setEnabled:YES];
    }
    else{
        [_divPopupBtn setEnabled:NO];
    }
     */
}


@end
