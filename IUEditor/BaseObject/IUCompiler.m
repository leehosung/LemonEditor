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


-(NSString*)editorSource:(IUDocument*)document{
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"webTemplate" ofType:@"html"];
    NSMutableString *source = [NSMutableString stringWithContentsOfFile:templateFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [[self editorHTML:document] stringByIndent:8 prependIndent:YES];
    [source replaceOccurrencesOfString:@"<!--HTML_Replacement-->" withString:html options:0 range:[source fullRange]];
    
    NSMutableString *css = [NSMutableString string];
    
    [css appendString:[NSString stringWithFormat:@"#%@ {", document.htmlID]];
    [css appendString:[self CSSContent:[document CSSAttributesForWidth:IUCSSTagDictionaryDefaultWidth]]];
    [css appendString:@"}"];
    [css appendString:@"\n"];
    for (IUObj *obj in document.allChildren) {
        [css appendString:[NSString stringWithFormat:@"#%@ {", obj.htmlID]];
        [css appendString:[self CSSContent:[obj CSSAttributesForWidth:IUCSSTagDictionaryDefaultWidth]]];
        [css appendString:@"}"];
        [css appendString:@"\n"];
    }
    [source replaceOccurrencesOfString:@"<!--CSS_Replacement-->" withString:[css stringByIndent:8 prependIndent:NO] options:0 range:[source fullRange]];
    
    [JDLogUtil log:IULogSource key:@"source" string:[@"\n" stringByAppendingString:source]];
    return source;
}




-(NSString*)editorHTML:(IUObj*)iu{
    NSMutableString *code = [NSMutableString string];

    if ([iu isKindOfClass:[IUObj class]]) {
        [code appendFormat:@"<div %@>", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes]];
        [code appendString:@"testme"];
        if (iu.children.count) {
            [code appendString:@"\n"];
            for (IUObj *child in iu.children) {
                [code appendString:[[self editorHTML:child] stringByIndent:4 prependIndent:YES]];
                [code appendString:@"\n"];
            }
        }
        [code appendFormat:@"</div>"];
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

-(IUCSSStringDictionary*)cssStringDictionaryWithCSSTagDictionary:(NSDictionary*)cssTagDict{
    IUCSSStringDictionary *dict = [IUCSSStringDictionary dictionary];
    for (IUCSSTag tag in cssTagDict) {
        if ([tag isSameTag:IUCSSTagFrameCollection]) {
            NSRect value = [cssTagDict[tag] rectValue];
            [dict putTag:@"left"    float:value.origin.x ignoreZero:NO unit:IUCSSUnitPixel];
            [dict putTag:@"top"     float:value.origin.y ignoreZero:YES unit:IUCSSUnitPixel];
            [dict putTag:@"width"   float:value.size.width ignoreZero:NO unit:IUCSSUnitPixel];
            [dict putTag:@"height"  float:value.size.height ignoreZero:NO unit:IUCSSUnitPixel];
        }
        else if ([tag isSameTag:IUCSSTagBGColor]){
            [dict putTag:@"background-color" color:cssTagDict[tag]];
        }
        else {
            [dict putTag:tag string:cssTagDict[tag]];
        }
    }
    return dict;
}

/*
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
*/



@end
