//
//  NSString+JDExtension.h
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JDExtension)

- (NSString*)JSEscape;
- (BOOL)isHTTPURL;


- (NSString*)lastLine;


- (NSString*)changeFileNameWithExtensionUntouched:(NSString*)fileName;
- (NSString*)stringByAppendFileNameWithExtensionUntouched:(NSString*)appendingString;

- (NSString*)stringByAppendingPathComponents:(NSArray*)paths;
- (NSString*)stringByPathDiff:(NSString*)path;

- (NSString*)stringByTrimEndWithChar:(char)c;
- (NSString*)trim;

- (NSString*) relativePathTo: (NSString*) endPath;
- (BOOL) containsString:(NSString*)string;

- (NSString*)nameWithoutExtensionAsFile;
- (NSString*)substringToChar:(unichar)charecter;
- (NSString*)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

- (NSString*)stringByChangeExtension:(NSString*)extension;
- (NSString*)stringByIndent:(NSUInteger)indent;

- (BOOL)isValidEmail;
#define RGXEmailPattern @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"

- (NSArray*) RGXMatchAllStringsWithPatten:(NSString*)patten;


@end

@interface NSMutableString(JDExtension)
- (void)appendString:(NSString*)string multipleTimes:(NSUInteger)multipleTimes;
- (void)appendStringIfNotNil:(NSString*)string;
@end
