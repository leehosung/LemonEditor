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
#import "IUImage.h"
#import "IUMovie.h"

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
    NSString *html = [[self outputHTML:document] stringByIndent:8 prependIndent:YES];
    [source replaceOccurrencesOfString:@"<!--HTML_Replacement-->" withString:html options:0 range:[source fullRange]];
    
    JDSectionInfoLog( IULogSource, @"source : %@", [@"\n" stringByAppendingString:source]);

    return source;
}

-(NSString*)cssSourceForIU:(IUBox*)iu width:(int)width{
    NSMutableString *css = [NSMutableString string];
    [css appendString:[NSString stringWithFormat:@"#%@ {", iu.htmlID]];
    [css appendString:[self CSSContentFromAttributes:[iu CSSAttributesForWidth:width] ofClass:iu isHover:NO]];
    [css appendString:@"}"];
    [css appendString:@"\n"];
    
    NSString *hoverCSS = [self CSSContentFromAttributes:[iu CSSAttributesForWidth:width] ofClass:iu isHover:YES];
    if (hoverCSS){
        [css appendString:[NSString stringWithFormat:@"#%@:hover {", iu.htmlID]];
        [css appendString:hoverCSS];
        [css appendString:@"}"];
        [css appendString:@"\n"];
        
    }
    return css;
}


-(NSString *)outputHTML:(IUBox *)iu{
    NSMutableString *code = [NSMutableString string];
    if ([iu isKindOfClass:[IUPage class]]) {
        IUPage *page = (IUPage*)iu;
        if (page.master) {
            [code appendFormat:@"<div %@ %@>\n", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:iu.HTMLOneAttribute]];
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
    
#pragma mark IUMovie
    else if([iu isKindOfClass:[IUMovie class]]){
        [code appendString:@"<video "];
        [code appendFormat:@"%@ %@", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:iu.HTMLOneAttribute]];
        [code appendString:@">"];
        
        if(((IUMovie *)iu).videoPath){
            NSMutableString *compatibilitySrc = [NSMutableString stringWithString:@"\
                                                 \n\t<source src=\"$moviename$\" type=\"video/$type$\">\
                                                 \n\t<object data=\"$moviename$\" width=\"100%\" height=\"100%\">\
                                                 \n\t\t<embed width=\"100%\" height=\"100%\" src=\"$moviename$\">\
                                                 \n\t</object>\
                                                 \n"];
            
            [compatibilitySrc replaceOccurrencesOfString:@"$moviename$" withString:((IUMovie *)iu).videoPath options:0 range:NSMakeRange(0, compatibilitySrc.length)];
            [compatibilitySrc replaceOccurrencesOfString:@"$type$" withString:((IUMovie *)iu).videoPath.pathExtension options:0 range:NSMakeRange(0, compatibilitySrc.length)];
            
            [code appendString:compatibilitySrc];
        }
        if( ((IUMovie *)iu).altText){
            [code appendString:((IUMovie *)iu).altText];
        }

        [code appendString:@"</video>"];
    }
#pragma mark IUImage
    else if([iu isKindOfClass:[IUImage class]]){
        [code appendFormat:@"<img %@ %@", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:iu.HTMLOneAttribute]];
        [code appendString:@">"];
        
    }
#pragma mark IUHTML
    else if([iu isKindOfClass:[IUHTML class]]){
        [code appendFormat:@"<div %@ %@>", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:iu.HTMLOneAttribute]];
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
#pragma mark IUBox
    else if ([iu isKindOfClass:[IUBox class]]) {
        [code appendFormat:@"<div %@ %@>", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:iu.HTMLOneAttribute]];
        if (iu.textHTML) {
            [code appendFormat:@"<p>%@</p>", iu.textHTML];
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
    
    if (iu.link) {
        NSString *linkURL = iu.link;
        if ([iu.link isHTTPURL] == NO) {
            linkURL = [NSString stringWithFormat:@"./%@.html", iu.link];
        }
        code = [NSMutableString stringWithFormat:@"<a href='%@'>%@</a>", linkURL, code];
    }
    return code;

}

-(NSString *)editorHTML:(IUBox*)iu{
    NSMutableString *code = [NSMutableString string];
    if ([iu isKindOfClass:[IUPage class]]) {
        IUPage *page = (IUPage*)iu;
        if (page.master) {
            [code appendFormat:@"<div %@ %@>\n", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:iu.HTMLOneAttribute]];
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
#pragma mark IUImage
    else if([iu isKindOfClass:[IUImage class]]){
        [code appendFormat:@"<img %@ %@", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:iu.HTMLOneAttribute]];
        [code appendString:@">"];
        
    }
#pragma mark IUMovie
    else if([iu isKindOfClass:[IUMovie class]]){
        [code appendString:@"<video "];
        NSMutableArray *oneAttributeArray = [iu.HTMLOneAttribute mutableCopy];
        [oneAttributeArray removeObject:@"autoplay"];
        [code appendFormat:@"%@ %@", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:oneAttributeArray]];
        [code appendString:@">"];
        
        if(((IUMovie *)iu).videoPath){
            NSMutableString *compatibilitySrc = [NSMutableString stringWithString:@"\
                                                 \n\t<source src=\"$moviename$\" type=\"video/$type$\">\
                                                 \n\t<object data=\"$moviename$\" width=\"100%\" height=\"100%\">\
                                                 \n\t\t<embed width=\"100%\" height=\"100%\" src=\"$moviename$\">\
                                                 \n\t</object>\
                                                 \n"];
            
            [compatibilitySrc replaceOccurrencesOfString:@"$moviename$" withString:((IUMovie *)iu).videoPath options:0 range:NSMakeRange(0, compatibilitySrc.length)];
            [compatibilitySrc replaceOccurrencesOfString:@"$type$" withString:((IUMovie *)iu).videoPath.pathExtension options:0 range:NSMakeRange(0, compatibilitySrc.length)];
            
            [code appendString:compatibilitySrc];
        }
        
        if( ((IUMovie *)iu).altText){
            [code appendString:((IUMovie *)iu).altText];
        }
        [code appendString:@"</video>"];
    }
#pragma mark IUHTML
    else if([iu isKindOfClass:[IUHTML class]]){
        [code appendFormat:@"<div %@ %@>", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:iu.HTMLOneAttribute]];
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
#pragma mark IUBox
    else if ([iu isKindOfClass:[IUBox class]]) {
        [code appendFormat:@"<div %@ %@>", [self HTMLAttributeStringWithTagDict:iu.HTMLAtributes], [self HTMLOneAttributeStringWithTagArray:iu.HTMLOneAttribute]];
        if (iu.textHTML) {
            [code appendFormat:@"<p>%@</p>", iu.textHTML];
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
    
    if (iu.link) {
        NSString *linkURL = iu.link;
        if ([iu.link isHTTPURL] == NO) {
            linkURL = [NSString stringWithFormat:@"./%@.html", iu.link];
        }
        code = [NSMutableString stringWithFormat:@"<a href='%@'>%@</a>", linkURL, code];
    }
    return code;
}


-(NSString *)HTMLOneAttributeStringWithTagArray:(NSArray *)tagArray{
    NSMutableString *code = [NSMutableString string];
    for (NSString *key in tagArray) {
        [code appendFormat:@"%@ ", key];

    }
    [code trim];
    return code;
}

-(NSString*)HTMLAttributeStringWithTagDict:(NSDictionary*)tagDictionary{
    NSMutableString *code = [NSMutableString string];
    for (NSString *key in tagDictionary) {
        
        //image tag attributes
        if([key isEqualToString:@"src"]){
            NSString *imagePath = [_resourceSource relativePathForResource:tagDictionary[key]];
            [code appendFormat:@"%@='%@' ", key, imagePath];
        }
        else{
            [code appendFormat:@"%@=%@ ", key, tagDictionary[key]];
        }
    }
    [code trim];
    return code;
}

-(NSString*)CSSContentFromAttributes:(NSDictionary*)cssTagDictionary ofClass:(IUBox*)obj isHover:(BOOL)isHover{
    //convert css tag dictionry to css string dictionary
    NSDictionary *cssStringDict = [self cssStringDictionaryWithCSSTagDictionary:cssTagDictionary ofClass:obj isHover:isHover];
    
    //convert css string dictionary to css line
    NSMutableString *code = [NSMutableString string];
    for (NSString *key in cssStringDict) {
        [code appendFormat:@"%@:%@; ", key, cssStringDict[key]];
    }
    return code;
}

-(IUCSSUnit)unitWithBool:(BOOL)value{
    if(value){
        return IUCSSUnitPercent;
    }
    else{
        return IUCSSUnitPixel;
    }
}


-(IUCSSStringDictionary*)cssStringDictionaryWithCSSTagDictionary:(NSDictionary*)cssTagDict ofClass:(IUBox*)obj isHover:(BOOL)isHover{
    if (_resourceSource == nil) {
        assert(0);
    }
    IUCSSStringDictionary *dict = [IUCSSStringDictionary dictionary];
    id value;
    
    if (isHover){
        if ([cssTagDict[IUCSSTagHoverBGImagePositionEnable] boolValue]) {
            value = cssTagDict[IUCSSTagHoverBGImageX];
            if (value) {
                [dict putTag:@"background-position-x" floatValue:[value floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
            }
            value = cssTagDict[IUCSSTagHoverBGImageY];
            if (value) {
                [dict putTag:@"background-position-y" floatValue:[value floatValue] ignoreZero:NO unit:IUCSSUnitPixel];
            }
        }
    }
    
    else {
        if ([obj.className isEqualToString:@"IUItem"]) {
            int i=0;
        }
        if (obj.hasX) {
            BOOL enablePercent =[cssTagDict[IUCSSTagXUnit] boolValue];
            IUCSSUnit unit =  [self unitWithBool:enablePercent];
            
            if(enablePercent){
                value = cssTagDict[IUCSSTagPercentX];
            }
            else{
                value = cssTagDict[IUCSSTagX];
            }
            
            if (value) {
                [dict putTag:@"left" floatValue:[value floatValue] ignoreZero:NO unit:unit];
            }
        }
        if (obj.hasY) {
            BOOL enablePercent =[cssTagDict[IUCSSTagYUnit] boolValue];
            IUCSSUnit unit = [self unitWithBool:enablePercent];
            
            if(enablePercent){
                value = cssTagDict[IUCSSTagPercentY];
            }
            else{
                value = cssTagDict[IUCSSTagY];
            }
            
            if (value) {
                
                if ([_flowIUs containsObject:[obj class]]) {
                    [dict putTag:@"margin-top" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                }
                else {
                    [dict putTag:@"top" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                }
                
                
            }
        }
        if (obj.hasWidth) {
            if ([obj isKindOfClass:[IUHeader class]] == NO) {
                
                BOOL enablePercent =[cssTagDict[IUCSSTagWidthUnit] boolValue];
                IUCSSUnit unit = [self unitWithBool:enablePercent];
                
                if(enablePercent){
                    value = cssTagDict[IUCSSTagPercentWidth];
                }
                else{
                    value = cssTagDict[IUCSSTagWidth];
                }
                if (value) {
                    
                    [dict putTag:@"width" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                }
            }
        }
        
        if (obj.hasHeight) {
            
            BOOL enablePercent =[cssTagDict[IUCSSTagHeightUnit] boolValue];
            IUCSSUnit unit = [self unitWithBool:enablePercent];
            
            if(enablePercent){
                value = cssTagDict[IUCSSTagPercentHeight];
            }
            else{
                value = cssTagDict[IUCSSTagHeight];
            }
            if (value) {
                if ([obj isKindOfClass:[IUHeader class]]) {
                    
                }
                [dict putTag:@"height" floatValue:[value floatValue] ignoreZero:NO unit:unit];
            }
            
        }
        
        value = cssTagDict[IUCSSTagHidden];
        [dict putTag:@"hidden" string:@"visibility"];
        
        NSColor *bgColor1 = cssTagDict[IUCSSTagBGGradientStartColor];
        NSColor *bgColor2 = cssTagDict[IUCSSTagBGGradientEndColor];
        
        if(bgColor1 || bgColor2){
            if(bgColor2 == nil){
                bgColor2 = [NSColor blackColor];
            }
            if(bgColor1 == nil){
                bgColor1 = [NSColor blackColor];
            }
            [dict putTag:@"background-color" color:bgColor1 ignoreClearColor:YES];
            

            NSString    *webKitStr = [NSString stringWithFormat:@"-webkit-gradient(linear, left top, left bottom, color-stop(0.05, %@), color-stop(1, %@));", bgColor1.rgbString, bgColor2.rgbString];
            NSString    *mozStr = [NSString stringWithFormat:@"	background:-moz-linear-gradient( center top, %@ 5%%, %@ 100%% );", bgColor1.rgbString, bgColor2.rgbString];
            NSString    *ieStr = [NSString stringWithFormat:@"filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='%@', endColorstr='%@', GradientType=0)", bgColor1.rgbString, bgColor2.rgbString];
            NSString *gradientStr = [webKitStr stringByAppendingFormat:@"%@ %@", mozStr, ieStr];
            
            [dict putTag:@"background" string:gradientStr];

        }
        else{
            value = cssTagDict[IUCSSTagBGColor];
            [dict putTag:@"background-color" color:value ignoreClearColor:YES];
        }
        
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
        
        //CSS - Border
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
        
        value = cssTagDict[IUCSSTagOverflow];
        if ([value integerValue]) {
            [dict putTag:@"overflow" string:@"visible"];
        }
        
        value = cssTagDict[IUCSSTagBorderRadiusTopLeft];
        if(value){
            [dict putTag:@"border-top-left-radius" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];}
        value = cssTagDict[IUCSSTagBorderRadiusTopRight];
        if(value){
            [dict putTag:@"border-top-right-radius" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];}
        value = cssTagDict[IUCSSTagBorderRadiusBottomLeft];
        if(value){
            [dict putTag:@"border-bottom-left-radius" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];}
        value = cssTagDict[IUCSSTagBorderRadiusBottomRight];
        if(value){
            [dict putTag:@"border-bottom-right-radius" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];}
        
        NSInteger hOff = [cssTagDict[IUCSSTagShadowHorizontal] integerValue];
        NSInteger vOff = [cssTagDict[IUCSSTagShadowVertical] integerValue];
        NSInteger blur = [cssTagDict[IUCSSTagShadowBlur] integerValue];
        NSInteger spread = [cssTagDict[IUCSSTagShadowSpread] integerValue];
        NSColor *color = cssTagDict[IUCSSTagShadowColor];
        NSString *colorString = [color rgbaString];
        if (colorString == nil){
            colorString = @"black";
        }
        if (hOff || vOff || blur || spread){
            [dict putTag:@"box-shadow" string:[NSString stringWithFormat:@"%ldpx %ldpx %ldpx %ldpx %@", hOff, vOff, blur, spread, colorString]];
        }
        
    }//========= end of else(not hover)=========
    return dict;
}


-(NSString *)fontCSSContentFromAttributes:(NSDictionary*)attributeDict{
    NSMutableString *retStr = [NSMutableString string];
    NSString *fontName = attributeDict[IUCSSTagFontName];
    if (fontName) {
        [retStr appendFormat:@"font-name : %@;\n", fontName];
    }
    NSNumber *fontSize = attributeDict[IUCSSTagFontSize];
    if (fontSize) {
        [retStr appendFormat:@"font-size : %dpx;\n", [fontSize intValue]];
    }
    return retStr;
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
