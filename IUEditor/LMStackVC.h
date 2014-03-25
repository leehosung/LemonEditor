//
//  LMStackVC.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUDocumentController.h"

@interface LMStackVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic)  IUDocument    *document;

@end