//
//  JDCode.m
//  IUEditor
//
//  Created by jd on 5/16/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "JDCode.h"
#import "NSString+JDExtension.h"
#include <stdarg.h>

@implementation JDCode{
    NSMutableString *string;
    NSInteger  indentLevel;
    NSMutableString *whiteSpace;
}

- (void)increaseIndentLevelForEdit{
    indentLevel ++;
    whiteSpace = [NSMutableString string];
    [whiteSpace appendString:@" " multipleTimes:indentLevel*4];
}
- (void)decreaseIndentLevelForEdit{
    indentLevel --;
    assert(indentLevel >= 0);
    whiteSpace = [NSMutableString string];
    [whiteSpace appendString:@" " multipleTimes:indentLevel*4];
}

- (void)addCodeLine:(NSString*)newCode{
    if (string.length) {
        if ([string characterAtIndex:[string length] - 1] != '\n') {
            [string appendString:@"\n"];
        }
    }
    [string appendString:whiteSpace];
    [string appendString:newCode];
}

- (void)addCode:(JDCode*)code{
    [code pushIndent:indentLevel*4 prependIndent:YES];
    [string appendString:code.string];
}

- (void)addCodeWithFormat:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    if ([string characterAtIndex:[string length] - 1] != '\n') {
        [string appendString:@"\n"];
    }
    [string appendString:whiteSpace];
    [string appendString:str];
}


-(void)addCodeLineWithFormat:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [self addCodeLine:str];
}

-(NSString*)string{
    return [string copy];
}

- (void)pushIndent:(NSUInteger)aIndentLevel prependIndent:(BOOL)prepend{
    NSMutableString *aWhiteSpace = [NSMutableString string];
    [aWhiteSpace appendString:@" " multipleTimes:aIndentLevel*4];

    if (prepend) {
        [string insertString:aWhiteSpace atIndex:0];
    }
    
    NSString *aWhiteStringAndNewLine = [aWhiteSpace stringByAppendingString:@"\n"];
    [string replaceOccurrencesOfString:@"\n" withString:aWhiteStringAndNewLine options:0 range:NSMakeRange(0, string.length)];
    
}

- (id)initWithCodeString:(NSString*)codeString{
    self = [super init];
    string = [codeString mutableCopy];
    whiteSpace = [NSMutableString string];
    return self;
}

- (id)init{
    self = [super init];
    string = [NSMutableString string];
    whiteSpace = [NSMutableString string];
    return self;
}


- (void)replaceCodeString:(NSString*)codeString toCode:(JDCode*)replacementCode{
    //get indent of codeString
    NSRange range = [string rangeOfString:codeString];
    
    NSUInteger space = 0;
    for (NSUInteger i = range.location; i > 0; i-- ) {
        unichar c = [string characterAtIndex:i];
        if (c == '\n') {
            break;
        }
        space ++;
    }
    
    [replacementCode pushIndent:space prependIndent:NO];
    [string replaceOccurrencesOfString:codeString withString:replacementCode.string options:0 range:NSMakeRange(0, string.length)];
}

- (void)removeBlock:(NSString *)blockIdentifier{
    NSString *startString = [NSString stringWithFormat:@"<!-- %@ Start -->", blockIdentifier];
    NSString *endString = [NSString stringWithFormat:@"<!-- %@ End -->", blockIdentifier];

    NSRange removeStart =[string rangeOfString:startString];
    NSRange removeEnd =[string rangeOfString:endString];
    NSRange removeRange = NSMakeRange(removeStart.location, removeEnd.location+removeEnd.length-removeStart.location);
    [string deleteCharactersInRange:removeRange];
}

- (void)replaceCodeString:(NSString *)code toCodeString:(NSString*)replacementString{
    [string replaceOccurrencesOfString:code withString:replacementString options:0 range:NSMakeRange(0, string.length)];
}
@end
