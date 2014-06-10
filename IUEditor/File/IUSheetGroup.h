//
//  IUSheetGroup.h
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUFileProtocol.h"

@class IUProject;
@class IUSheet;

@interface IUSheetGroup : NSObject < NSCoding>

@property IUProject *project;
@property NSString *name;

- (NSArray*)childrenFiles;
- (void)removeSheet:(IUSheet*)document;
- (void)addSheet:(IUSheet*)document;

@end