//
//  IUProjectDocument.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 9..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUProject.h"
#import "LMWC.h"

@interface IUProjectDocument : NSDocument

@property IUProject *project;

- (LMWC *)lemonWindowController;

@end
