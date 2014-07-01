//
//  LMFileNaviVC.h
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUProject.h"
#import "JDOutlineView.h"
#import "IUSheetController.h"
#import "IUIdentifierManager.h"

@interface LMFileNaviVC : NSViewController <NSOutlineViewDelegate, NSMenuDelegate>

@property (nonatomic, readonly) id  selection;
@property (strong, nonatomic) IBOutlet _binding_ IUSheetController *documentController;
@property (nonatomic) IUProject *project;


-(void)selectFirstDocument;
@end
