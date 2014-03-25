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

@interface IUDocumentGroup : NSObject <IUNode, NSCoding>

@property (nonatomic)   NSString *name;
@property (nonatomic, readonly) NSMutableArray *children;

-(void)addDocument:(IUDocument*)document;
-(void)addDocumentGroup:(IUDocumentGroup*)node;


@end