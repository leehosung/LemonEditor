//
//  NSCoder+JDExtension.h
//  IUEditor
//
//  Created by jd on 3/22/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCoder (JDExtension)
-(void) encodeFromObject:(id)obj withProperties:(NSArray*)properties;
-(void) decodeToObject:(id)obj withProperties:(NSArray*)properties;
@end