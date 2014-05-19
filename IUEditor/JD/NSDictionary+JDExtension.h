//
//  NSDictionary+JDExtension.h
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JDExtension)
-(NSDictionary*)deepCopy;
-(BOOL)writeAsJSONFile:(NSString *)path atomically:(BOOL)atomically;
+(NSDictionary*)dictionaryWithJSONContentsOfFile:(NSString *)path;

@end

@interface NSMutableDictionary (JDExtension)

- (void)setOrRemoveObject:(id)object forKey:(id)key;
- (void)overwrite:(NSDictionary*)dict;
-(NSMutableDictionary*)deepCopy;
@end