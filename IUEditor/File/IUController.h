//
//  IUController.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//
//  Manage IUObj in file

#import <Cocoa/Cocoa.h>
#import "IUDocument.h"

@interface IUController : NSTreeController

@property IUDocument *document;

-(void)addIUToTrash:(IUObj* )IUObj;

@end
