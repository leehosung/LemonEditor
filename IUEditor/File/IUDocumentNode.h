//
//  IUFileNode.h
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUDocumentNode : NSObject

@property   NSString    *name;

-(NSMutableArray*)children;

@end
