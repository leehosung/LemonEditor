//
//  LMFileNaviVC.h
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUProject.h"
#import "IUDocumentController.h"

@interface LMFileNaviVC : NSViewController <IUProjectDelegate>

@property (nonatomic, readonly) id  selection;
@property (strong, nonatomic) IBOutlet NSTreeController *documentController;
@property (nonatomic) IUProject *project;

-(void)selectFirstDocument;
@end
