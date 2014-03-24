//
//  IUResourceGroup.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUDocumentNode.h"

@interface IUResourceGroup : IUDocumentNode <NSCoding>

@property IUDocumentNode    *parent;

- (BOOL)syncDir;
- (NSString*)path;

@end