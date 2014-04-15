//
//  IUIdentifierManager.h
//  IUEditor
//
//  Created by jd on 4/11/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IUBox;
@interface IUIdentifierManager : NSObject
-(void)addIUs:(NSArray*)IUs;
-(void)addIU:(IUBox*)IU;
-(NSString*)requestNewIdentifierWithKey:(NSString*)identifier;
-(void)removeIdentifier:(NSString*)identifier;
@end
