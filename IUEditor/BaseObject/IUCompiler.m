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
#import "IUHeader.h"
#import "IUPageContent.h"
#import "IUMaster.h"
#import "IUHTML.h"

@implementation IUCompiler{
    NSArray *_flowIUs;
}

-(id)init{
    self = [super init];
    if (self) {
        _flowIUs = @[[IUHeader class], [IUPageContent class]];
    }
    return self;
}

-(NSString*)editorSource:(IUDocument*)document{
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"webTemplate" ofType:@"html"];
    NSMutableString *source = [NSMutableString stringWithContentsOfFile:templateFilePath encoding:NSUTF8StringEncoding error:nil];

    //change css
    NSMutableString *css = [NSMutableString string];
    
    
    [css appendString:[self cssSourceForIU:document width:IUCSSDefaultCollection]];
    for (IUBox *obj in document.allChildren) {
        [css appendString:[self cssSourceForIU:obj width:IUCSSDefaultCollection]];
    }
    [source replaceOccurrencesOfString:@"<!--CSS_Replacement-->" withString:[css stringByIndent:8 prependIndent:NO] options:0 range:[source fullRange]];

    //change html
    NSString *html = [[self editorHTML:document] stringByIndent:8 prependIndent:YES];
    [source replaceOccurrencesOfString:@"<!--HTML_Replacement-->" withString:html options:0 range:[source fullRange]];
    
    JDSectionInfoLog( IULogSource, @"source : %@", [@"\n" stringByAppendingString:source]);

    return source;
}

-(NSString*)cssSourceForIU:(IUBox*)iu width:(int)width{
    NSMutableString *css = [NSMutableString string];
    [css appendString:[NSString stringWithFormat:@"#%@ {", iu.htmlID]];
    [css appendString:[self CSSContentFromAttributes:[iu CSSAttributesForWidth:IUCSSDefaultCollection] ofClass:iu]];
    [css appendString:@"}"];
    [css appendString:@"\n"];
    return css;
}


-(NSString*)editorHTML:(IUBox*)iu{
    NSMutableString *code = [NSMutableString string];
    if ([iu isKindOfClass:[IUPage class]]) {
        IUPage *page = (IUPage*)iu;
        if (page.master) {
            [code appendFormat:@"<div %@>\n", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes]];
            for (IUBox *obj in page.master.children) {
                [code appendString:[[self editorHTML:obj] stringByIndent:4 prependIndent:YES]];
                [code appendString:@"\n"];
            }
            if (iu.children.count) {
                for (IUBox *child in iu.children) {
                    if (child == page.master) {
                        continue;
                    }
                    [code appendString:[[self editorHTML:child] stringByIndent:4 prependIndent:YES]];
                    [code appendString:@"\n"];
                }
            }
            [code appendString:@"</div>"];
        }
    }
    else if([iu isKindOfClass:[IUHTML class]]){
        [code appendFormat:@"<div %@>", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes]];
        if(((IUHTML *)iu).hasInnerHTML){
            [code appendString:((IUHTML *)iu).innerHTML];
        }
        if (iu.children.count) {
            [code appendString:@"\n"];
            for (IUBox *child in iu.children) {
                [code appendString:[[self editorHTML:child] stringByIndent:4 prependIndent:YES]];
                [code appendString:@"\n"];
            }
        }
        [code appendFormat:@"</div>"];
        
    }
    else if ([iu isKindOfClass:[IUBox class]]) {
        [code appendFormat:@"<div %@>", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes]];
        [code appendString:@"<p>testme</p>"];
        if (iu.children.count) {
            [code appendString:@"\n"];
            for (IUBox *child in iu.children) {
                [code appendString:[[self editorHTML:child] stringByIndent:4 prependIndent:YES]];
                [code appendString:@"\n"];
            }
        }
        [code appendFormat:@"</div>"];
    }
    
    if (iu.link) {
        NSString *linkURL = iu.link;
        if ([iu.link isHTTPURL] == NO) {
            linkURL = [NSString stringWithFormat:@"./%@.html", iu.link];
        }
        code = [NSMutableString stringWithFormat:@"<a href='%@'>%@</a>", linkURL, code];
    }
    return code;
}


-(NSString*)HTMLAttributeStringWithTagDict:(NSDictionary*)tagDictionary{
    NSMutableString *code = [NSMutableString string];
    for (NSString *key in tagDictionary) {
        [code appendFormat:@"%@=%@ ", key, tagDictionary[key]];
    }
    [code trim];
    return code;
}

-(NSString*)CSSContentFromAttributes:(NSDictionary*)cssTagDictionary ofClass:(IUBox*)obj{
    //convert css tag dictionry to css string dictionary
    NSDictionary *cssStringDict = [self cssStringDictionaryWithCSSTagDictionary:cssTagDictionary ofClass:obj];
    
    //convert css string dictionary to css line
    NSMutableString *code = [NSMutableString string];
    for (NSString *key in cssStringDict) {
        [code appendFormat:@"%@:%@; ", key, cssStringDict[key]];
    }
    return code;
}


-(IUCSSStringDictionary*)cssStringDictionaryWithCSSTagDictionary:(NSDictionary*)cssTagDict ofClass:(IUBox*)obj{
    if (_resourceSource == nil) {
        assert(0);
    }
    IUCSSStringDictionary *dict = [IUCSSStringDictionary dictionary];
    id value;
    
    if (obj.hasX) {
        value = cssTagDict[IUCSSTagX];
        if (value) {
            [dict putTag:@"left" floatValue:[value floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
        }
    }
    if (obj.hasY) {
        value = cssTagDict[IUCSSTagY];
        if (value) {
            if ([_flowIUs containsObject:[obj class]]) {
                [dict putTag:@"margin-top" floatValue:[value floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
            }
            else {
                [dict putTag:@"top" floatValue:[value floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
            }
        }
    }

    if (obj.hasWidth) {
        if ([obj isKindOfClass:[IUHeader class]] == NO) {
            value = cssTagDict[IUCSSTagWidth];
            if (value) {
                [dict putTag:@"width" floatValue:[value floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
            }
        }
    }
    
    if (obj.hasHeight) {
        value = cssTagDict[IUCSSTagHeight];
        if (value) {
            if ([obj isKindOfClass:[IUHeader class]]) {
                
            }
            [dict putTag:@"height" floatValue:[value floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
        }
    }
    

    value = cssTagDict[IUCSSTagBGColor];
    [dict putTag:@"background-color" color:value ignoreClearColor:YES];
    
    value = cssTagDict[IUCSSTagImage];
    NSString *resourcePath = [_resourceSource relativePathForResource:value];
    [dict putTag:@"background-image" string:[resourcePath CSSURLString]];
    
    value = cssTagDict[IUCSSTagBGSize];
    if ([value isEqualToString:@"Auto"] == NO) {
        [dict putTag:@"background-size" string:value];
    }
    
    value = cssTagDict[IUCSSTagBGXPosition];
    [dict putTag:@"background-position-x" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];

    value = cssTagDict[IUCSSTagBGYPosition];
    [dict putTag:@"background-position-y" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];

    value = cssTagDict[IUCSSTagBorderLeftWidth];
    if (value) {
        [dict putTag:@"border-left-width" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];
        NSColor *color = cssTagDict[IUCSSTagBorderLeftColor];
        [dict putTag:@"border-left-color" color:color ignoreClearColor:YES];
    }
    value = cssTagDict[IUCSSTagBorderRightWidth];
    if (value) {
        [dict putTag:@"border-right-width" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];
        NSColor *color = cssTagDict[IUCSSTagBorderRightColor];
        [dict putTag:@"border-right-color" color:color ignoreClearColor:YES];
    }    value = cssTagDict[IUCSSTagBorderBottomWidth];
    if (value) {
        [dict putTag:@"border-bottom-width" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];
        NSColor *color = cssTagDict[IUCSSTagBorderBottomColor];
        [dict putTag:@"border-bottom-color" color:color ignoreClearColor:YES];
    }    value = cssTagDict[IUCSSTagBorderTopWidth];
    if (value) {
        [dict putTag:@"border-top-width" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];
        NSColor *color = cssTagDict[IUCSSTagBorderTopColor];
        [dict putTag:@"border-top-color" color:color ignoreClearColor:YES];
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
