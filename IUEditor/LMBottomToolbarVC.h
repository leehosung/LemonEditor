//
//  LMToolbarVC.h
//  IUEditor
//
//  Created by jd on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUResourceManager.h"
#import "IUSheet.h"

@interface LMBottomToolbarVC : NSViewController <NSComboBoxDelegate>

@property (nonatomic) IUResourceManager     *resourceManager;
@property (nonatomic) IUSheet    *sheet;

@end
