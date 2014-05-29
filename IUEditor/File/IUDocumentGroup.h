//
//  IUDocumentNode.h
//  IUEditor
//
//  Created by JD on 3/26/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUFileProtocol.h"

@class IUProject;
@class IUDocument;

@interface IUDocumentGroup : NSObject < NSCoding>

@property IUProject *project;
@property NSString *name;

- (NSArray*)children;
- (void)removeDocument:(IUDocument*)document;
- (void)addDocument:(IUDocument*)document;

@end