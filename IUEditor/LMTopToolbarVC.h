//
//  LMTopToolbarVC.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IUDocumentController.h"
#import "IUDocumentGroup.h"
#import "LMFileTabItemVC.h"

typedef enum{
    LMTabDocumentTypeNone,
    LMTabDocumentTypeOpen,
    LMTabDocumentTypeHidden,
    
}LMTabDocumentType;

@interface LMTopToolbarVC : NSViewController

@property (nonatomic)  IUDocumentController *documentController;
@property (nonatomic)  IUDocument    *document;


//tabItem delegate
- (void)selectTab:(IUDocument *)documentNode;
- (void)closeTab:(LMFileTabItemVC *)documentNode;

@end
