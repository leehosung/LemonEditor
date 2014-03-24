//
//  IUDirectoryNode.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUDocumentNode.h"

@class IUDocument;

@interface IUDocumentGroupNode : IUDocumentNode  <NSCoding>


-(void)addDocument:(IUDocument*)document;
-(void)addDocumentGroup:(IUDocumentGroupNode*)node;


@end
