//
//  IUProjectController.h
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IUProject;
@interface IUProjectController : NSTreeController

@property (nonatomic) IUProject *project;

@end
