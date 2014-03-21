//
//  IUCSS.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUClass.h"

@interface IUCSS : IUClass

-(void)setStyle:(NSString*)name data:(id)data frame:(NSInteger)frame;
-(void)requestStyle:(NSString*)name;

-(void)setHoverStyle:(NSString*)name data:(id)data frame:(NSInteger)frame;
-(void)requestHoverStyle:(NSString*)name;

-(void)importFromDict:(NSDictionary*)dict;
-(NSMutableDictionary*)exportAsDict;

@end
