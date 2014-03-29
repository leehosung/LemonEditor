//
//  IUCompiler.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUCompiler.h"
#import "NSString+JDExtension.h"
#import "IUDocument.h"
#import "NSDictionary+JDExtension.h"
#import "JDUIUtil.h"

@implementation IUCompiler

-(NSString*)generateOutputSource{
    assert(0);
    return nil;
}

-(NSString*)generateEditorSource:(IUDocument*)document{
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"webTemplate" ofType:@"html"];
    NSMutableString *source = [NSMutableString stringWithContentsOfFile:templateFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [self generateEditorHTML:document];
    [source replaceOccurrencesOfString:@"<!--HTML_Replacement-->" withString:html options:0 range:[source fullRange]];
    
    NSMutableString *css = [NSMutableString string];
    
    [css appendString:[NSString stringWithFormat:@"#%@ {", document.htmlID]];
    [css appendString:[self CSSContent:[document CSSAttributesForDefault]]];
    [css appendString:@"}"];
    [css appendString:@"\n"];
    for (IUObj *obj in document.allChildren) {
        [css appendString:[NSString stringWithFormat:@"#%@:{", obj.htmlID]];
        [css appendString:[self CSSContent:[obj CSSAttributesForDefault]]];
        [css appendString:@"}"];
        [css appendString:@"\n"];
    }
    [source replaceOccurrencesOfString:@"<!--CSS_Replacement-->" withString:css options:0 range:[source fullRange]];
    
    [JDLogUtil log:IULogSource  log:source];
    return source;
}


-(NSString*)generateEditorHTML:(IUObj*)iu{
    NSMutableString *code = [NSMutableString string];

    if ([iu isKindOfClass:[IUObj class]]) {
        [code appendFormat:@"<div %@>", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes]];
        for (IUObj *child in iu.children) {
            [code appendString:[self generateEditorHTML:child]];
        }
        [code appendString:@"testme"];
        [code appendFormat:@"</>"];
        return code;
    }
    assert(0);
    return nil;
}


-(NSString*)HTMLAttributeStringWithTagDict:(NSDictionary*)tagDictionary{
    NSMutableString *code = [NSMutableString string];
    for (NSString *key in tagDictionary) {
        [code appendFormat:@"%@=%@ ", key, tagDictionary[key]];
    }
    [code trim];
    return code;
}

-(NSString*)CSSContent:(NSDictionary*)cssTagDictionary{
    //convert css tag dictionry to css string dictionary
    NSDictionary *cssStringDict = [self cssStringDictionaryWithCSSTagDictionary:cssTagDictionary];
    
    //convert css string dictionary to css line
    NSMutableString *code = [NSMutableString string];
    for (NSString *key in cssStringDict) {
        [code appendFormat:@"%@:%@; ", key, cssStringDict[key]];
    }
    return code;
}

-(NSDictionary*)cssStringDictionaryWithCSSTagDictionary:(NSDictionary*)cssTagDict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString* key in cssTagDict) {
        [self insert:dict style:key value:cssTagDict[key]];
    }
    return dict;
}

-(void)insert:(NSMutableDictionary*)dict style:(NSString*)tag value:(id)value{
    if ([tag isEqualToString:@"background-color"]) {
        [self insert:dict string:[value rgbString] forTag:tag];
    }
    else if ([tag isEqualToString:@"position"]) {
        [self insert:dict string:value forTag:tag];
    }
}


-(void)insert:(NSMutableDictionary*)dict string:(NSString*)value forTag:(NSString*)tag{
    if ([value length]) {
        [dict setObject:value forKey:tag];
    }
    else{
        [dict removeObjectForKey:tag];
    }
}




@end
