//
//  JDCode.h
//  IUEditor
//
//  Created by jd on 5/16/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDCode : NSObject
- (void)increaseIndentLevelForEdit;
- (void)decreaseIndentLevelForEdit;

- (void)addCodeLine:(NSString*)code;
- (void)addCodeLineWithFormat:(NSString*)format, ...;

- (void)addCode:(JDCode*)code;
- (void)addCodeWithFormat:(NSString *)format, ...;
- (NSString*)string;

- (void)pushIndent:(NSUInteger)indentLevel prependIndent:(BOOL)prepend;

- (void)replaceCodeString:(NSString*)code toCode:(JDCode*)code;

- (id)initWithCodeString:(NSString*)codeString;

- (void)removeBlock:(NSString*)blockIdentifier;

- (void)replaceCodeString:(NSString *)code toCodeString:(NSString*)replacementString;
@end