//
//  IUClass.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

NSArray* GetPropertyList(Class a);

@interface IUClass : NSObject
-(id)instatiate;
+(NSArray*)propertyList;

// Save + Load
-(void)importFromDict:(NSDictionary*)dict;
-(NSMutableDictionary*)dict;

@end