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

@property (nonatomic) NSString *targetProjectDirectory;
@property NSString *iuProjectDirectory;
@property NSString *buildProjectDirectory;
@property NSString *resourceProjectDirectory;

@property (nonatomic) IUProject *currentProject;


- (NSString *)outputFilePath;

@end
