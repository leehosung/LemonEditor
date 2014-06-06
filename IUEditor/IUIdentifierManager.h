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

-(void)resetUnconfirmedIUs;
-(void)confirm;

-(void)registerIUs:(NSArray*)IUs;

/**
 @brief Assign object html id
 @note This function does not assign html id of children. Call this function for each child.
 */
-(void)setNewIdentifierAndRegisterToTemp:(IUBox*)obj withKey:(NSString*)keyString;


/**
 @breif Get IU with identifier
 @note This function is used in FileNaviVC
 @return IU which has identifier
 */
-(IUBox*)IUWithIdentifier:(NSString*)identifier;

@end
