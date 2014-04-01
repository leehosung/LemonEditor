//
//  IUDirectoryNode.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUNode.h"

@class IUDocument;

@interface IUDocumentGroupNode : IUNode < NSCoding>

-(void)addDocument:(IUDocument*)document name:(NSString*)name;
-(void)addDocumentGroupNode:(IUDocumentGroupNode*)node;

-(NSArray*)allDocuments;

@end