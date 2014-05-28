//
//  LMProjectConvertWC.h
//  IUEditor
//
//  Created by jd on 5/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IUProject.h"

@interface LMProjectConvertWC : NSWindowController

@property NSString *targetProjectDirectory;

@property IUProject *currentProject;


- (NSString *)outputFilePath;

@end
