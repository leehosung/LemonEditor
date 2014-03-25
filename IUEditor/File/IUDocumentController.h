//
//  IUDocumentController.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUProject.h"
#import "IUDocument.h"

@interface IUDocumentController : NSTreeController

-(id)initWithDocument:(IUDocument*)document;

@property (nonatomic, readonly) IUDocument *document;

@end