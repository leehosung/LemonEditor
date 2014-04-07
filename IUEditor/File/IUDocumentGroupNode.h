//
//  IUDirectoryNode.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUGroupNode.h"

@class IUDocument;

@interface IUDocumentGroupNode : IUGroupNode < NSCoding>

-(NSArray*)allDocuments;
@end