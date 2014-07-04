//
//  LMResourceVC.h
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUResourceManager.h"
#import "LMDragAndDropButton.h"
@interface LMResourceVC : NSViewController <NSOpenSavePanelDelegate>

@property (nonatomic) IUResourceManager *manager;

@end
