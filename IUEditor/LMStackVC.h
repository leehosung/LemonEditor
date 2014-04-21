//
//  LMStackVC.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUDocumentController.h"
#import "IUController.h"

@interface LMStackOutlineView : NSOutlineView

@end

@interface LMStackVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property  IUDocument    *document;
@property (strong) IBOutlet IUController *IUController;
@end