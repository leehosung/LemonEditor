//
//  LMFileTabVC.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUDocumentController.h"
#import "IUDocumentNode.h"

@interface LMTabBox : NSBox

@property IBOutlet id delegate;

@end

@interface LMFileTabItemVC : NSViewController

@property id delegate;
@property (weak) IBOutlet NSButton *fileNameBtn;
@property  IUDocumentNode *documentNode;


@end
