//
//  IUFileNode.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUDocumentController.h"

@interface IUFile : NSTreeNode

-(id)initAsPageWithName:(NSString*)name;
-(id)initAsMasterWithName:(NSString*)name;
-(id)initAsComponentWithName:(NSString*)name;


@end