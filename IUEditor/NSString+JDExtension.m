//
//  NSString+JDExtension.m
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSString+JDExtension.h"

@implementation NSString (JDExtension)

-(NSString*)JSEscape{
    NSMutableString *str = [self mutableCopy];
    [str replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0    range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"'" withString:@"\\'" options:0    range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:0    range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"\n" withString:@"\\n" options:0    range:NSMakeRange(0, [str length])];
    return str;
}

- (NSString*)lastLine{
    NSInteger len = [self length];
    NSInteger i;
    for (i=len-1; i>=0; i--) {
        unichar c = [self characterAtIndex:i];
        if (c == '\n') {
            break;
        }
    }
    return [self substringFromIndex:i+1];
}



- (NSString*)substringToChar:(unichar)charecter{
    NSUInteger len = [self length];
    int i;
    for (i=0; i<len-1; i++) {
        unichar c = [self characterAtIndex:i];
        if (c == charecter) {
            break;
        }
    }
    return [self substringToIndex:i];
}
- (NSString*)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    return [[self substringToIndex:to] substringFromIndex:from];
}

- (NSString*)stringByAppendingPathComponents:(NSArray*)paths{
    NSString *str = [self copy];
    for (NSString *path in paths) {
        str = [str stringByAppendingPathComponent:path];
    }
    return str;
}

- (NSString*)stringByPathDiff:(NSString*)path{
    NSMutableString *val = [self mutableCopy];
    [val replaceOccurrencesOfString:path withString:@"" options:0 range: NSMakeRange(0, [self length])];
    if ([val characterAtIndex:0] == '/') {
        val = [[val substringFromIndex:1] mutableCopy];
    }
    return [NSString stringWithString:val];
}


- (BOOL)isHTTPURL{
    if ([self length] > 7) {
        if ([[self substringToIndex:7] isEqualToString:@"http://"]) {
            return YES;
        }
    }
    return NO;
}

-(NSString*)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString*)stringByTrimEndWithChar:(char)c{
    NSInteger idx = [self length] -1;
    if (idx < 0) {
        return nil;
    }
    while (1) {
        char strC = [self characterAtIndex:idx];
        if (strC == c) {
            idx --;
        }
        else{
            break;
        }
    }
    if (idx == -1) {
        return [self copy];
    }
    return [self substringToIndex:idx+1];
}

- (NSString*)nameWithoutExtensionAsFile{
    NSString *fileName = [self lastPathComponent];
    NSString *extension = [NSString stringWithFormat:@".%@", [self pathExtension]];
    return [fileName stringByReplacingOccurrencesOfString:extension withString:@""];
}

- (NSString*)changeFileNameWithExtensionUntouched:(NSString*)newFileName{
    NSString *path = [self stringByDeletingLastPathComponent];
    NSString *extension = [self pathExtension];
    return [NSString stringWithFormat:@"%@/%@.%@",path,newFileName,extension];
}

- (NSString*)stringByChangeExtension:(NSString*)extension{
    NSString *path = [[self stringByDeletingPathExtension] stringByAppendingFormat:@".%@",extension];
    return path;
}

- (NSString*)stringByIndent:(NSUInteger)indent{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"\n"];
    [str appendString:@" " multipleTimes:indent];
    
    NSString *newStr = [self stringByReplacingOccurrencesOfString:@"\n" withString:str];
    
    NSMutableString *resultStr = [NSMutableString string];
    [resultStr appendString:@" " multipleTimes:indent];
    [resultStr appendString:newStr];
    NSString *fStr = [resultStr stringByTrimEndWithChar:' '];
    return fStr;
}


- (NSString*)stringByAppendFileNameWithExtensionUntouched:(NSString*)appendingString{
    NSString *path = [self stringByDeletingLastPathComponent];
    NSString *fileName = [self nameWithoutExtensionAsFile];
    NSString *extension = [self pathExtension];
    NSString *newFileName = [fileName stringByAppendingString:appendingString];
    
    if ([path isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@.%@",newFileName,extension];
    }
    return [NSString stringWithFormat:@"%@/%@.%@",path,newFileName,extension];
}


// Assumes that self and endPath are absolute file paths.
// Example: [ @"/a/b/c/d" relativePathTo: @"/a/e/f/g/h"] => @"../../e/f/g/h".
- (NSString*) relativePathTo: (NSString*) endPath {
    NSAssert( ! [self isEqual: endPath], @"illegal link to self");
    NSArray* startComponents = [self pathComponents];
    NSArray* endComponents = [endPath pathComponents];
    NSMutableArray* resultComponents = nil;
    int prefixCount = 0;
    if( ! [self isEqual: endPath] ){
        int iLen = MIN((int)[startComponents count], (int) [endComponents count]);
        for(prefixCount = 0; prefixCount < iLen && [[startComponents objectAtIndex: prefixCount] isEqual: [endComponents objectAtIndex: prefixCount]]; ++prefixCount){}
    }
    if(0 == prefixCount){
        resultComponents = [NSMutableArray arrayWithArray: endComponents];
    }else{
        resultComponents = [NSMutableArray arrayWithArray: [endComponents subarrayWithRange: NSMakeRange(prefixCount, [endComponents count] - prefixCount)]];
        int lifterCount = (int)[startComponents count] - prefixCount;
        if(1 == lifterCount){
            [resultComponents insertObject: @"." atIndex: 0];
        }else{
            --lifterCount;
            for(int i = 0; i < lifterCount; ++i){
                [resultComponents insertObject: @".." atIndex: 0];
            }
        }
    }
    return [NSString pathWithComponents: resultComponents];
}

- (BOOL) containsString:(NSString*)string{
    if ([self rangeOfString:string].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}


- (BOOL)isValidEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}


- (NSArray*) RGXMatchAllStringsWithPatten:(NSString*)patten{
    NSRegularExpression *rgx=[NSRegularExpression regularExpressionWithPattern:patten options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    NSArray *matches= [rgx matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    NSMutableArray *retArray= [NSMutableArray array];
    
    int modifier;
    
    for (modifier=0; modifier<[patten length]; modifier++) {
        char characterAtIndex=[patten characterAtIndex:modifier];
        char characterBeforeIndex='\0';
        if (modifier>0) {
            characterBeforeIndex=[patten characterAtIndex:modifier-1];
        }
        if ( ( characterAtIndex=='[' || characterAtIndex == '.' || characterAtIndex == '(' ) && characterBeforeIndex != '\\'  ) {
            //found
            break;
        }
    }
    
    for (NSTextCheckingResult *match in matches) {
        
        [retArray addObject:[self substringWithRange:match.range]];
    }
    return [NSArray arrayWithArray:retArray];
}





@end

@implementation NSMutableString(JDExtension)
- (void)appendString:(NSString*)string multipleTimes:(NSUInteger)multipleTimes{
    for (int i=0; i<multipleTimes; i++) {
        [self appendString:string];
    }
}

- (void)appendStringIfNotNil:(NSString*)string{
    if (string == nil) {
        return;
    }
    else{
        [self appendString:string];
    }
}

@end