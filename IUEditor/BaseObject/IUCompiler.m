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
#import "IUPage.h"
#import "IUMaster.h"

@implementation IUCompiler


-(NSString*)editorSource:(IUDocument*)document{
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"webTemplate" ofType:@"html"];
    NSMutableString *source = [NSMutableString stringWithContentsOfFile:templateFilePath encoding:NSUTF8StringEncoding error:nil];

    //change css
    NSMutableString *css = [NSMutableString string];
    
    
    [css appendString:[self cssSourceForIU:document width:IUCSSDefaultCollection]];
    for (IUObj *obj in document.allChildren) {
        [css appendString:[self cssSourceForIU:obj width:IUCSSDefaultCollection]];
    }
    [source replaceOccurrencesOfString:@"<!--CSS_Replacement-->" withString:[css stringByIndent:8 prependIndent:NO] options:0 range:[source fullRange]];

    //change html
    NSString *html = [[self editorHTML:document] stringByIndent:8 prependIndent:YES];
    [source replaceOccurrencesOfString:@"<!--HTML_Replacement-->" withString:html options:0 range:[source fullRange]];
    
    JDSectionInfoLog( IULogSource, @"source : %@", [@"\n" stringByAppendingString:source]);

    return source;
}

-(NSString*)cssSourceForIU:(IUObj*)iu width:(int)width{
    NSMutableString *css = [NSMutableString string];
    [css appendString:[NSString stringWithFormat:@"#%@ {", iu.htmlID]];
    [css appendString:[self CSSContentFromAttributes:[iu CSSAttributesForWidth:IUCSSDefaultCollection] ofClass:self]];
    [css appendString:@"}"];
    [css appendString:@"\n"];
    return css;
}


-(NSString*)editorHTML:(IUObj*)iu{
    if ([iu isKindOfClass:[IUPage class]]) {
        IUPage *page = (IUPage*)iu;
        if (page.master) {
            NSMutableString *code = [NSMutableString string];
            [code appendFormat:@"<div %@>\n", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes]];
            for (IUObj *obj in page.master.children) {
                [code appendString:[[self editorHTML:obj] stringByIndent:4 prependIndent:YES]];
                [code appendString:@"\n"];
            }
            [code appendString:@"    <div class='IUPageContent'>\n"];
            if (iu.children.count) {
                for (IUObj *child in iu.children) {
                    if (child == page.master) {
                        continue;
                    }
                    [code appendString:[[self editorHTML:child] stringByIndent:8 prependIndent:YES]];
                    [code appendString:@"\n"];
                }
            }
            [code appendString:@"    </div>\n"];
            [code appendString:@"</div>"];
            return code;
        }
    }
    if ([iu isKindOfClass:[IUObj class]]) {
        NSMutableString *code = [NSMutableString string];
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

-(NSString*)CSSContentFromAttributes:(NSDictionary*)cssTagDictionary ofClass:(IUObj*)obj{
    //convert css tag dictionry to css string dictionary
    NSDictionary *cssStringDict = [self cssStringDictionaryWithCSSTagDictionary:cssTagDictionary ofClass:obj];
    
    //convert css string dictionary to css line
    NSMutableString *code = [NSMutableString string];
    for (NSString *key in cssStringDict) {
        [code appendFormat:@"%@:%@; ", key, cssStringDict[key]];
    }
    return code;
}

-(IUCSSStringDictionary*)cssStringDictionaryWithCSSTagDictionary:(NSDictionary*)cssTagDict ofClass:(IUObj*)obj{
    IUCSSStringDictionary *dict = [IUCSSStringDictionary dictionary];
    for (IUCSSTag tag in cssTagDict) {
        if ([tag isSameTag:IUCSSTagX]) {
            [dict putTag:@"left"    floatValue:[cssTagDict[tag] floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
        }
        else if ([tag isSameTag:IUCSSTagY]){
            [dict putTag:@"top"    floatValue:[cssTagDict[tag] floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
        }
        else if ([tag isSameTag:IUCSSTagWidth]){
            [dict putTag:@"width"    floatValue:[cssTagDict[tag] floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
        }
        else if ([tag isSameTag:IUCSSTagHeight]){
            [dict putTag:@"height"    floatValue:[cssTagDict[tag] floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
        }
        else if ([tag isSameTag:IUCSSTagBGColor]){
            [dict putTag:@"background-color" color:cssTagDict[tag]];
        }
        else if ([tag isSameTag:IUCSSTagImage]){
            [dict putTag:@"background-image" string:[_resourcePaths[cssTagDict[tag]] CSSURLString]];
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
