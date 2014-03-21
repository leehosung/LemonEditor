//
//  NSMutableDictionary+IUTag.h
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMDExIgnoreZero @"ignoreZero"
#define kMDExIgnoreNil @"ignoreNil"
#define kMDExModifier   @"modifier"
#define kMDExModifierParam  @"modifierParam"
#define kMDExOutputDictKey  @"outputDictKey"
#define kMDExDictForTrue    @"dictForTrue"
#define kMDExDefault    @"default"

#define kMDExModifierPixel @"px"
#define kMDExModifierURL @"url"
#define kMDExModifierPercent @"percent"


@interface NSMutableDictionary (IUTag)

-(void)putTag:(NSString*)tag intValue:(int)intValue param:(NSDictionary*)param;
-(void)putTag:(NSString*)tag floatValue:(float)intValue param:(NSDictionary*)param;
-(void)putTag:(NSString*)tag stringValue:(NSString*)stringValue param:(NSDictionary*)param;
-(void)removeTags:(NSArray*)tags;
-(void)removeTag:(id)key;
-(void)mergeTagDictionary:(NSDictionary*)tagDict;


@end
