//
//  IUFileNode.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUDocumentController.h"

@interface IUDocumentControllerNode : NSTreeNode <NSCoding>

-(id)initWithDocument:(IUDocument*)document;

@end