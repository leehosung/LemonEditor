//
//  IUManager.h
//  IUEditor
//
//  Created by jd on 4/7/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IUObj;

@interface IUManager : NSObject
-(void)registerIU:(IUObj*)iu;
-(NSString*)requestNewIDWithIdentifier:(NSString*)identifier;
@end