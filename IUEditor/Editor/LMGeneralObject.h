//
//  LMGeneralObject.h
//  IUEditor
//
//  Created by JD on 3/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMGeneralObject : NSObject
@property   NSString    *title;
@property   NSImage     *image;
@property   NSString    *description;

//override following objects
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(id)valueForUndefinedKey:(NSString *)key;

@end
