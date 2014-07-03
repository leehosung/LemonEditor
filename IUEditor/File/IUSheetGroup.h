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

@interface IUSheetGroup : NSObject < NSCoding, NSCopying>

@property IUProject *project;
@property NSString *name;

- (NSArray*)childrenFiles;
- (void)addSheet:(IUSheet*)sheet;
- (void)removeSheet:(IUSheet *)sheet;
- (void)changeIndex:(IUSheet *)sheet toIndex:(NSUInteger)newIndex;

@end