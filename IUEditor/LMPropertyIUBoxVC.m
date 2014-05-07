//
//  LMPropertyIUBoxVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUBoxVC.h"
#import "IUDocumentNode.h"
#import "IUDocument.h"

@interface LMPropertyIUBoxVC ()

@property (strong) IBOutlet NSArrayController *pageDocumentAC;
@property (strong) IBOutlet NSArrayController *divAC;

@property (weak) IBOutlet NSComboBox *linkCB;
@property (weak) IBOutlet NSPopUpButton *divPopupBtn;
@property (weak) IBOutlet NSTextField *textVariableTF;

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
    [_pageDocumentAC bind:NSContentArrayBinding toObject:self withKeyPath:@"pageDocumentNodes" options:IUBindingDictNotRaisesApplicable];
    [_linkCB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"link"] options:nil];
    [_textVariableTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"textVariable"] options:nil];
    [_divPopupBtn bind:NSSelectedValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"] options:IUBindingDictNotRaisesApplicable];
    
    [self.controller addObserver:self forKeyPath:@"selection" options:NSKeyValueObservingOptionInitial context:nil];

}

- (BOOL)isPage:(NSString *)link{
    for(IUDocumentNode *node in _pageDocumentNodes){
        if([node.name isEqualToString:link]){
            return YES;
        }
    }
    return NO;
}
- (IBAction)clickLinkComboBox:(id)sender {
    [self setDivLink];
}

- (void)selectionDidChange:(NSDictionary *)change{
    [self setDivLink];
}

- (void)setDivLink{
    NSString *link = [[_linkCB selectedCell] stringValue];
    [_divAC setContent:nil];

    if([self isPage:link]){
        IUDocumentNode *node = [[_pageDocumentAC selectedObjects] objectAtIndex:0];
        IUDocument *document = node.document;
        [_divAC addObjects:document.allChildren];
        [_divPopupBtn setEnabled:YES];
    }
    else{
        [_divPopupBtn setEnabled:NO];
    }
}


@end
