//
//  IUResourceGroup.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUFileProtocol.h"

@protocol IUResourcePathProtocol <NSObject>
@optional
- (NSString*)relativePath;
- (NSString*)absolutePath;
@end

@class IUResourceFile;

@interface IUResourceGroup : NSObject <IUFile, IUResourcePathProtocol, NSCoding>
@property NSString *name;
@property id <IUResourcePathProtocol> parent;

- (IUResourceFile*)addResourceFileWithData:(NSData*)data;
- (IUResourceFile*)addResourceFileWithContentOfPath:(NSString*)filePath;
- (IUResourceGroup *)addResourceGroupWithName:(NSString*)groupName;

@end