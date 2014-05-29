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
#import "IUClass.h"
#import "IUBackground.h"
#import "IUTextField.h"
#import "IUTextView.h"

#import "IUHTML.h"
#import "IUImage.h"
#import "IUMovie.h"
#import "IUWebMovie.h"
#import "IUFBLike.h"
#import "IUCarousel.h"
#import "IUItem.h"
#import "IUCarouselItem.h"
#import "IUCollection.h"
#import "IUSubmitButton.h"
#import "IUForm.h"
#import "IUPageLinkSet.h"
#import "IUTransition.h"
#import "JDCode.h"
#import "IUText.h"
#import "LMFontController.h"

@implementation IUCompiler{
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(JDCode *)metadataSource:(IUPage *)page{

    JDCode *code = [[JDCode alloc] init];
    //for google
    if(page.title && page.title.length != 0){
        [code addCodeLineWithFormat:@"<title>%@</title>", page.title];
        [code addCodeLineWithFormat:@"<meta name='og:title' content='%@'>", page.title];
    }
    if(page.description && page.description.length != 0){
        [code addCodeLineWithFormat:@"<meta name='description' content='%@'>", page.description];
        [code addCodeLineWithFormat:@"<meta name='og:description' content='%@'>", page.description];
    }
    if(page.keywords && page.keywords.length != 0){
        [code addCodeLineWithFormat:@"<meta name='keywords' content='%@'>", page.keywords];
    }
    if(page.author && page.author.length != 0){
        [code addCodeLineWithFormat:@"<meta name='author' content='%@'>", page.author];
    }

    return code;
}

-(JDCode *)webfontImportSourceForEdit{
    
    JDCode *code = [[JDCode alloc] init];
    LMFontController *fontController = [LMFontController sharedFontController];
    for(NSDictionary *dict  in fontController.fontDict.allValues){
        if([[dict objectForKey:LMFontNeedLoad] boolValue]){
            NSString *fontHeader = [dict objectForKey:LMFontHeaderLink];
            [code addCodeLine:fontHeader];
        }
    }
    
    return code;
}

-(JDCode *)webfontImportSourceForOutput:(IUPage *)page{
    NSMutableArray *fontNameArray = [NSMutableArray array];
    for (IUBox *box in page.allChildren){
        if([box isKindOfClass:[IUText class]]){
            for(NSString *fontName in [(IUText *)box fontNameArray]){
                if([fontNameArray containsString:fontName] == NO){
                    [fontNameArray addObject:fontName];
                }
            }
        }
        else{
            NSString *fontName = [box.css valueForKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagFontName]];
            if([fontNameArray containsString:fontName] == NO){
                [fontNameArray addObject:fontName];
            }
        }
    }
    JDCode *code = [[JDCode alloc] init];
    LMFontController *fontController = [LMFontController sharedFontController];
    
    for(NSString *fontName in fontNameArray){
        if([fontController isNeedHeader:fontName]){
            [code addCodeLine:[fontController headerForFontName:fontName]];
        }
    }
    
    return code;
}


-(NSString*)outputSource:(IUDocument*)document mqSizeArray:(NSArray *)mqSizeArray{
    if ([document isKindOfClass:[IUClass class]]) {
        return [self outputHTML:document].string;
    }
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"webTemplate" ofType:@"html"];
    
    JDCode *sourceCode = [[JDCode alloc] initWithCodeString: [NSString stringWithContentsOfFile:templateFilePath encoding:NSUTF8StringEncoding error:nil]];

    //replace metadata;
    if([document isKindOfClass:[IUPage class]]){
        JDCode *metaCode = [self metadataSource:(IUPage *)document];
        [sourceCode replaceCodeString:@"<!--METADATA_Insert-->" toCode:metaCode];
        
        JDCode *webFontCode = [self webfontImportSourceForOutput:(IUPage *)document];
        [sourceCode replaceCodeString:@"<!--WEBFONT_Insert-->" toCode:webFontCode];

        
        //remove iueditor.js to make outputSource
        [sourceCode removeBlock:@"IUEditor.JS"];
        
        //insert event.js
        NSString *eventJs = @"<script type=\"text/javascript\" src=\"Resource/JS/iuevent.js\"></script>";
        [sourceCode replaceCodeString:@"<!-- IUEvent.JS -->" toCodeString:eventJs];
        
        NSString *initJS = @"<script type=\"text/javascript\" src=\"Resource/JS/iuinit.js\"></script>";
        [sourceCode replaceCodeString:@"<!-- IUInit.JS -->" toCodeString:initJS];
        
        
        //change css
        NSMutableArray *cssSizeArray = [mqSizeArray mutableCopy];
        //remove default size
        [cssSizeArray removeObjectAtIndex:0];
        JDCode *cssCode = [self cssSource:document cssSizeArray:cssSizeArray];
        [sourceCode replaceCodeString:@"<!--CSS_Replacement-->" toCode:cssCode];
        
        //change html
        JDCode *htmlCode = [self outputHTML:document];
        [sourceCode replaceCodeString:@"<!--HTML_Replacement-->" toCode:htmlCode];
        
        JDSectionInfoLog( IULogSource, @"source : %@", [@"\n" stringByAppendingString:sourceCode.string]);
        
        if (_rule == IUCompileRuleDjango) {
            [sourceCode replaceCodeString:@"\"Resource/" toCodeString:@"\"/Resource/"];
            [sourceCode replaceCodeString:@"./Resource/" toCodeString:@"/Resource/"];
            [sourceCode replaceCodeString:@"('Resource/" toCodeString:@"('/Resource/"];
        }
    }
    
    
    return sourceCode.string;
}

-(NSString*)editorSource:(IUDocument*)document mqSizeArray:(NSArray *)mqSizeArray{
    NSString *templateFilePath = [[NSBundle mainBundle] pathForResource:@"webTemplate" ofType:@"html"];
    
    
    NSMutableString *sourceString = [NSMutableString stringWithContentsOfFile:templateFilePath encoding:NSUTF8StringEncoding error:nil];
    
    JDCode *sourceCode = [[JDCode alloc] initWithCodeString:sourceString];
    
    
    JDCode *webFontCode = [self webfontImportSourceForEdit];
    [sourceCode replaceCodeString:@"<!--WEBFONT_Insert-->" toCode:webFontCode];
    
    //change css
    NSMutableArray *cssSizeArray = [mqSizeArray mutableCopy];
    //remove default size
    [cssSizeArray removeObjectAtIndex:0];
    JDCode *cssCode = [self cssSource:document cssSizeArray:cssSizeArray];
    [sourceCode replaceCodeString:@"<!--CSS_Replacement-->" toCode:cssCode];
    
    //change html
    JDCode *htmlCode = [self editorHTML:document];
    [sourceCode replaceCodeString:@"<!--HTML_Replacement-->" toCode:htmlCode];
    

    
    JDSectionInfoLog( IULogSource, @"source : %@", [@"\n" stringByAppendingString:sourceCode.string]);

    return sourceCode.string;
}

-(JDCode *)cssSource:(IUDocument *)document cssSizeArray:(NSArray *)cssSizeArray{
    JDCode *code = [[JDCode alloc] init];
//    NSMutableString *css = [NSMutableString string];
    //default-
    [code addCodeLine:@"<style id=default>"];
    [code increaseIndentLevelForEdit];

    NSDictionary *cssDict = [self cssSourceForIU:document width:IUCSSMaxViewPortWidth];
    for (NSString *identifier in cssDict) {
        [code addCodeLineWithFormat:@"%@ {%@}", identifier, cssDict[identifier]];
    }
    NSSet *districtChildren = [NSSet setWithArray:document.allChildren];

    for (IUBox *obj in districtChildren) {
        NSDictionary *cssDict = [self cssSourceForIU:obj width:IUCSSMaxViewPortWidth];
        for (NSString *identifier in cssDict) {
            [code addCodeLineWithFormat:@"%@ {%@}", identifier, cssDict[identifier]];
        }
    }
    [code decreaseIndentLevelForEdit];
    [code addCodeLine:@"</style>"];
    
#pragma mark extract MQ css
    //mediaQuery css
    //remove default size
    for(NSNumber *sizeNumber in cssSizeArray){
        int size = [sizeNumber intValue];
        
        //        <style type="text/css" media="screen and (max-width:400px)" id="style400">
        [code addCodeLine:@"<style type=\"text/css\" "];
        [code addCodeWithFormat:@"media ='screen and (max-width:%dpx)' id='style%d'>" , size, size];
        [code increaseIndentLevelForEdit];
        
        NSDictionary *cssDict = [self cssSourceForIU:document width:size];
        for (NSString *identifier in cssDict) {
            if ([[cssDict[identifier] stringByTrim]length]) {
                [code addCodeLineWithFormat:@"%@ {%@}", identifier, cssDict[identifier]];
            }
        }
        
        NSSet *districtChildren = [NSSet setWithArray:document.allChildren];
        
        for (IUBox *obj in districtChildren) {
            NSDictionary *cssDict = [self cssSourceForIU:obj width:size];
            for (NSString *identifier in cssDict) {
                if ([[cssDict[identifier] stringByTrim]length]) {
                    [code addCodeLineWithFormat:@"%@ {%@}", identifier, cssDict[identifier]];
                }
            }
        }
        [code decreaseIndentLevelForEdit];
        [code addCodeLine:@"</style>"];
    }
    
    return code;
}

-(JDCode *)cssContentForIUCarouselPager:(IUCarousel *)iu hover:(BOOL)hover{
    JDCode *code = [[JDCode alloc] init];
    if(hover){
        //fall back
        [code addCodeLineWithFormat:@"background:%@ !important;", [iu.selectColor cssBGString]];
    }else{
        [code addCodeLineWithFormat:@"background:%@ !important;", [iu.deselectColor cssBGString]];
    }
    return code;
}

- (NSString *)cssContentForIUCarouselArrow:(IUCarousel *)iu hover:(BOOL)hover location:(IUCarouselArrow)location carouselHeight:(NSInteger)height{
    
    
    NSMutableString *css = [NSMutableString string];
    NSString *imageName;
    if(location == IUCarouselArrowLeft){
        imageName = iu.leftArrowImage;
    }
    else if(location == IUCarouselArrowRight){
        imageName = iu.rightArrowImage;
    }
    
    NSImage *arrowImage;
    if ([imageName isHTTPURL]) {
        [css appendFormat:@"background:(%@) ;", imageName];
        arrowImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:imageName]];
    }
    else{
        NSString *imageRelativePath = [_resourceSource relativePathForResource:imageName];
        [css appendFormat:@"background:%@ ;", [imageRelativePath CSSURLString]];
        NSString *imageAbsolutePath = [_resourceSource absolutePathForResource:imageName];
        arrowImage = [[NSImage alloc] initWithContentsOfFile:imageAbsolutePath];
    }
    
    [css appendFormat:@"height:%.0fpx ; ",arrowImage.size.height];
    [css appendFormat:@"width:%.0fpx ;", arrowImage.size.width];
    [css appendFormat:@"top:%.0fpx ;", (height/2-arrowImage.size.height/2)];

    
    return css;
}

-(NSDictionary *)cssSourceForIUPageLinkSet:(IUPageLinkSet *)iu{
    NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    
    switch (iu.pageLinkAlign) {
        case IUAlignLeft: break;
        case IUAlignRight:{
            NSString *identifier = [[iu.htmlID cssClass] stringByAppendingString:@" > div"];
            [returnDict setObject:identifier forKey:@"float:right;"];
        }
        case IUAlignCenter:{
            NSString *identifier = [[iu.htmlID cssClass] stringByAppendingString:@" > div"];
            [returnDict setObject:identifier forKey:@"margin:auto;"];
        }
        default:  break;
    }
    
    NSMutableString *pgLinkButton = [NSMutableString string];
    CGFloat height = [iu.css.assembledTagDictionary[IUCSSTagHeight] floatValue];
    [pgLinkButton appendFormat:@"    display:block; width:%.1fpx; height:%.1fpx; margin-left:%.1fpx; margin-right: %.1fpx; line-height:%.1fpx;", height, height, iu.buttonMargin, iu.buttonMargin, height];
    [pgLinkButton appendFormat:@"    background-color:%@;", [iu.defaultButtonBGColor cssBGString]];

    [returnDict setObject:pgLinkButton forKey:[iu.htmlID.cssClass stringByAppendingString:@" > div > ul > a > li"]];
    [returnDict setObject:[iu.selectedButtonBGColor rgbString] forKey:[[iu.htmlID cssClass] stringByAppendingString:@" selected > div > ul > a > li"]];

    return returnDict;
}


-(NSDictionary *)cssDictionaryForIUCarousel:(IUCarousel *)iu{
    
    NSMutableDictionary *css = [NSMutableDictionary dictionary];
    if(iu.enableColor){
        NSString *itemID = [NSString stringWithFormat:@"#%@pager-item", iu.htmlID];
        [css setObject:[self cssContentForIUCarouselPager:iu hover:NO] forKey:itemID];
        [css setObject:[self cssContentForIUCarouselPager:iu hover:YES] forKey:[itemID cssHoverClass]];
        [css setObject:[self cssContentForIUCarouselPager:iu hover:YES] forKey:[itemID cssActiveClass]];
    }
    
    if([iu.leftArrowImage isEqualToString:@"Default"] == NO){
        NSInteger currentHeight = [iu.css.assembledTagDictionary[IUCSSTagHeight] integerValue];
        
        NSString *leftArrowID = [NSString stringWithFormat:@".%@ .bx-wrapper .bx-controls-direction .bx-prev", iu.htmlID];
        NSString *string = [self cssContentForIUCarouselArrow:iu hover:NO location:IUCarouselArrowLeft carouselHeight:currentHeight];
        [css setObject:string forKey:leftArrowID];
    }
    if([iu.rightArrowImage isEqualToString:@"Default"] == NO){
        NSInteger currentHeight = [iu.css.assembledTagDictionary[IUCSSTagHeight] integerValue];
        NSString *rightArrowID = [NSString stringWithFormat:@".%@ .bx-wrapper .bx-controls-direction .bx-next", iu.htmlID];
        NSString *string = [self cssContentForIUCarouselArrow:iu hover:NO location:IUCarouselArrowRight carouselHeight:currentHeight];
        [css setObject:string forKey:rightArrowID];
    }

    return css;
}

-(NSDictionary*)cssSourceForIU:(IUBox*)iu width:(int)width{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    BOOL isDefaultWidth = (width == IUCSSMaxViewPortWidth) ? YES : NO;
    NSString *defaultCSSString = [self CSSContentFromAttributes:[iu CSSAttributesForWidth:width] ofClass:iu isHover:NO isDefaultWidth:isDefaultWidth];
    [dict setObject:defaultCSSString forKey:[NSString stringWithFormat:@".%@", iu.htmlID]];
    
    NSString *hoverCSS = [self CSSContentFromAttributes:[iu CSSAttributesForWidth:width] ofClass:iu isHover:YES isDefaultWidth:isDefaultWidth];
    if ([[hoverCSS stringByTrim] length]) {
        [dict setObject:hoverCSS forKey:[NSString stringWithFormat:@".%@:hover", iu.htmlID]];
    }
    
    if([iu isKindOfClass:[IUText class]]){
        IUText *textIU = (IUText *)iu;
        NSDictionary *textCSSDict = textIU.textController.cssDict;
        for(NSString *textIdentifier in textCSSDict.allKeys){
            NSString *textCSSStr = [self fontCSSContentFromAttributes:[textIU textCSSAttributesForWidth:width textIdentifier:textIdentifier]];
            [dict setObject:textCSSStr forKey:[NSString stringWithFormat:@"#%@",textIdentifier]];
        }
    }
    
    
    if([iu isKindOfClass:[IUCarousel class]] && width == IUCSSMaxViewPortWidth){
        NSDictionary * carouselDict =[self cssDictionaryForIUCarousel:(IUCarousel *)iu];
        for (id key in carouselDict) {
            [dict setObject:carouselDict[key] forKey:key];
        }
    }
    
    if ([iu isKindOfClass:[IUPageLinkSet class]] && width == IUCSSMaxViewPortWidth) {
        NSDictionary *pagelinkSetDict = [self cssSourceForIUPageLinkSet:(IUPageLinkSet *)iu];
        for (id key in pagelinkSetDict) {
            [dict setObject:pagelinkSetDict[key] forKey:key];
        }
    }
    return dict;
}

static NSString * IUCompilerTagOption = @"tag";
-(JDCode*)outputHTMLAsBox:(IUBox*)iu option:(NSDictionary*)option{
    NSString *tag = @"div";
    if ([iu isKindOfClass:[IUForm class]]) {
        tag = @"form";
    }
    else if (iu.textType == 1){
        tag = @"h1";
    }
    else if (iu.textType == 2){
        tag = @"h2";
    }
    JDCode *code = [[JDCode alloc] init];
    if ([iu.pgVisibleCondition length] && _rule == IUCompileRuleDjango) {
        [code addCodeLineWithFormat:@"{%%if %@%%}", iu.pgVisibleCondition];
    }
    [code addCodeLineWithFormat:@"<%@ %@>", tag, [self HTMLAttributes:iu option:nil]];
    if ([iu isKindOfClass:[IUForm class]]) {
        [code addCodeLine:@"{% csrf_token %}"];
    }
    if (_rule == IUCompileRuleDjango && iu.textVariable) {
        if ([iu.document isKindOfClass:[IUClass class]]){
            [code addCodeLineWithFormat:@"<p>{{ object.%@ }}</p>", iu.textVariable];
        }
        else {
            [code addCodeLineWithFormat:@"<p>{{ %@ }}</p>", iu.textVariable];
        }
    }
    if (iu.children.count) {
        for (IUBox *child in iu.children) {
            [code addCode:[self outputHTML:child]];
        }
    }
    [code addCodeLineWithFormat:@"</%@>", tag];
    if ([iu.pgVisibleCondition length] && _rule == IUCompileRuleDjango) {
        [code addCodeLine:@"{% endif %}"];
    }
    return code;
}

-(JDCode *)outputHTML:(IUBox *)iu{
    JDCode *code = [[JDCode alloc] init];
#pragma mark IUPage
    if ([iu isKindOfClass:[IUPage class]]) {
        IUPage *page = (IUPage*)iu;
        if (page.background) {
            [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
            for (IUBox *obj in page.background.children) {
                [code addCode:[self outputHTML:obj]];
            }
            if (iu.children.count) {
                [code increaseIndentLevelForEdit];
                for (IUBox *child in iu.children) {
                    if (child == page.background) {
                        continue;
                    }
                    [code addCode:[self outputHTML:child]];
                }
                [code decreaseIndentLevelForEdit];
            }
            [code addCodeLine:@"</div>"];
        }
        else {
            [code addCode:[self outputHTMLAsBox:iu option:nil]];
        }
    }
#pragma mark IUCollection
    else if ([iu isKindOfClass:[IUCollection class]]){
        IUCollection *iuCollection = (IUCollection*)iu;
        if (_rule == IUCompileRuleDjango ) {
            [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:iuCollection option:nil]];
            [code addCodeLineWithFormat:@"    {%% for object in %@ %%}", iuCollection.collectionVariable];
            [code addCodeLineWithFormat:@"        {%% include '%@.html' %%}", iuCollection.prototypeClass.name];
            [code addCodeLine:@"    {% endfor %}"];
            [code addCodeLineWithFormat:@"</div>"];
        }
        else {
            assert(0);
        }
    }
#pragma mark IUCarouselItem
    else if([iu isKindOfClass:[IUCarouselItem class]]){
        [code addCodeLine:@"<li>"];
        [code increaseIndentLevelForEdit];
        [code addCode:[self outputHTMLAsBox:iu option:nil]];
        [code decreaseIndentLevelForEdit];
        [code addCodeLine:@"</li>"];
    }
#pragma mark IUCarousel
    else if([iu isKindOfClass:[IUCarousel class]]){
        [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:iu option:nil]];
        [code addCodeLineWithFormat:@"<ul class='bxslider' id='bxslider_%@'>\n", iu.htmlID];
        
        for(IUItem *item in iu.children){
            [code addCode:[self outputHTML:item]];
        }
        
        [code addCodeLine:@"</ul></div>"];
    }
#pragma mark IUMovie
    else if([iu isKindOfClass:[IUMovie class]]){
        [code addCodeLineWithFormat:@"<video %@>", [self HTMLAttributes:iu option:nil]];
        
        if(((IUMovie *)iu).videoPath){
            NSMutableString *compatibilitySrc = [NSMutableString stringWithString:@"\
                <source src=\"$moviename$\" type=\"video/$type$\">\n\
                    <object data=\"$moviename$\" width=\"100%\" height=\"100%\">\n\
                    <embed width=\"100%\" height=\"100%\" src=\"$moviename$\">\n\
                </object>"];
            
            [compatibilitySrc replaceOccurrencesOfString:@"$moviename$" withString:((IUMovie *)iu).videoPath options:0 range:NSMakeRange(0, compatibilitySrc.length)];
            [compatibilitySrc replaceOccurrencesOfString:@"$type$" withString:((IUMovie *)iu).videoPath.pathExtension options:0 range:NSMakeRange(0, compatibilitySrc.length)];
            
            [code addCodeLine:compatibilitySrc];
        }
        if( ((IUMovie *)iu).altText){
            [code addCodeLine:((IUMovie *)iu).altText];
        }

        [code addCodeLine:@"</video>"];
    }
#pragma mark IUImage
    else if([iu isKindOfClass:[IUImage class]]){
        [code addCodeLineWithFormat:@"<img %@ >", [self HTMLAttributes:iu option:nil]];
        
    }
#pragma mark IUHTML
    else if([iu isKindOfClass:[IUHTML class]]){
        [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:iu option:nil]];
        if(((IUHTML *)iu).hasInnerHTML){
            [code addCodeLine:((IUHTML *)iu).innerHTML];
        }
        if (iu.children.count) {
            for (IUBox *child in iu.children) {
                [code addCode:[self outputHTML:child]];
            }
        }
        [code addCodeLineWithFormat:@"</div>"];
        
    }
#pragma mark IUPageLinkSet

    else if ([iu isKindOfClass:[IUPageLinkSet class]]){
        [code addCodeLineWithFormat:@"<div %@>\n", [self HTMLAttributes:iu option:nil]];
        [code addCodeLine:@"    <div>"];
        [code addCodeLine:@"    <ul>"];
        [code addCodeLineWithFormat:@"        {%% for i in %@ %%}", [(IUPageLinkSet *)iu pageCountVariable]];
        [code addCodeLineWithFormat:@"        <a href=/%@/{{i}}>", iu.link];
        [code addCodeLine:@"            <li> {{i}} </li>"];
        [code addCodeLine:@"        </a>"];
        [code addCodeLine:@"        {% endfor %}"];
        [code addCodeLine:@"    </ul>"];
        [code addCodeLine:@"    </div>"];
        [code addCodeLine:@"</div>"];
    }
#pragma mark IUImport
    else if([iu isKindOfClass:[IUImport class]]){
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
        if (iu.children.count) {
            for (IUBox *child in iu.children) {
                [code addCode:[self outputHTML:child]];
            }
        }
        [code addCodeLineWithFormat:@"</div>"];
        
    }
#pragma mark IUText
    else if([iu isKindOfClass:[IUText class]]){
        IUText *textIU = (IUText *)iu;
        if (_rule == IUCompileRuleDjango && iu.textVariable) {
            JDCode *outputCode = [self outputHTMLAsBox:iu option:nil];
            [code addCode:outputCode];
        }
        else{
            [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
            if (textIU.textHTML) {
                [code addCodeLineWithFormat:textIU.textHTML];
            }
            [code addCodeLineWithFormat:@"</div>"];
        }

    }
#pragma mark IUTextFeild
    
    else if ([iu isKindOfClass:[IUTextField class]]){
        [code addCodeLineWithFormat:@"<input %@ >", [self HTMLAttributes:iu option:nil]];
    }
    
#pragma mark IUTextView
    
    else if ([iu isKindOfClass:[IUTextView class]]){
        NSString *inputValue = [[(IUTextView *)iu inputValue] length] ? [(IUTextView *)iu inputValue] : @"";
        [code addCodeLineWithFormat:@"<textarea %@ >%@</textarea>", [self HTMLAttributes:iu option:nil], inputValue];
    }
    
    else if ([iu isKindOfClass:[IUForm class]]){
        [code addCode:[self outputHTMLAsBox:iu option:nil]];
    }
    else if ([iu isKindOfClass:[IUSubmitButton class]]){
        [code addCodeLineWithFormat:@"<input %@ >", [self HTMLAttributes:iu option:nil]];
    }
    

#pragma mark IUBox
    else if ([iu isKindOfClass:[IUBox class]]) {
        JDCode *outputCode = [self outputHTMLAsBox:iu option:nil];
        [code addCode:outputCode];
    }
    
    if (iu.link && [iu isKindOfClass:[IUPageLinkSet class]] == NO) {
        NSString *linkURL = iu.link;
        if ([iu.link isHTTPURL] == NO) {
            if (_rule == IUCompileRuleDjango) {
                if(iu.divLink){
                    linkURL = [NSString stringWithFormat:@"/%@#%@", [iu.link lowercaseString], iu.divLink];
                }
                else{
                    linkURL = [NSString stringWithFormat:@"/%@", [iu.link lowercaseString]];
                }
            }
            else {
                if(iu.divLink){
                    linkURL = [NSString stringWithFormat:@"./%@.html#%@", iu.link, iu.divLink];
                }
                else{
                    linkURL = [NSString stringWithFormat:@"./%@.html", iu.link];
                }
            }
        }
        NSString *str = [NSString stringWithFormat:@"<a href='%@'>", linkURL];
        [code wrapTextWithStartString:str endString:@"</a>"];
    }
    return code;

}

- (JDCode*)editorHTMLAsBOX:(IUBox *)iu{
    JDCode *code = [[JDCode alloc] init];
    [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
    if (iu.children.count) {
        for (IUBox *child in iu.children) {
            [code addCode:[self editorHTML:child]];
        }
    }
    [code addCodeLineWithFormat:@"</div>"];
    return code;
}

-(JDCode *)editorHTML:(IUBox*)iu{
    JDCode *code = [[JDCode alloc] init];
#pragma mark IUPage
    if ([iu isKindOfClass:[IUPage class]]) {
        IUPage *page = (IUPage*)iu;
        if (page.background) {
            [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
            for (IUBox *obj in page.background.children) {
                [code increaseIndentLevelForEdit];
                [code addCode:[self editorHTML:obj]];
                [code decreaseIndentLevelForEdit];
            }
            if (iu.children.count) {
                for (IUBox *child in iu.children) {
                    if (child == page.background) {
                        continue;
                    }
                    [code increaseIndentLevelForEdit];
                    [code addCode:[self editorHTML:child]];
                    [code decreaseIndentLevelForEdit];
                }
            }
            [code addCodeLine:@"</div>"];
        }
        else {
            [code addCode:[self editorHTMLAsBOX:iu]];
        }
    }
#pragma mark IUCarouselItem
    else if([iu isKindOfClass:[IUCarouselItem class]]){
        [code addCodeLine:@"<li>"];
        [code increaseIndentLevelForEdit];
        [code addCode:[self editorHTMLAsBOX:iu]];
        [code decreaseIndentLevelForEdit];
        [code addCodeLine:@"</li>"];
    }
#pragma mark IUCarousel
    else if([iu isKindOfClass:[IUCarousel class]]){
        [code addCodeLineWithFormat:@"<div %@>", [self HTMLAttributes:iu option:nil]];
        [code addCodeLineWithFormat:@"<ul class='bxslider' id='bxslider_%@'>", iu.htmlID];

        for(IUItem *item in iu.children){
            [code addCode:[self editorHTML:item]];
        }
        
        [code addCodeLine:@"</ul></div>"];
    }
#pragma mark IUImage
    else if([iu isKindOfClass:[IUImage class]]){
        IUImage *iuImage = (IUImage *)iu;
        if(iuImage.imageName){
            [code addCodeLineWithFormat:@"<img %@ >", [self HTMLAttributes:iu option:nil]];
        }
        //editor mode에서는 default image 를 만들어줌
        else{
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"tool_image" ofType:@"tiff"];
            [code addCodeLineWithFormat:@"<img %@ src='%@' >",  [self HTMLAttributes:iu option:nil], imagePath];

        }
    }
#pragma mark IUMovie
    else if([iu isKindOfClass:[IUMovie class]]){

        NSDictionary *dict = [NSDictionary dictionaryWithObject:@[@(1)] forKey:@[@"editor"]];
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:dict]];
        
        IUMovie *iuMovie = (IUMovie *)iu;
        
        NSString *thumbnailPath;
        if(iuMovie.posterPath){
            thumbnailPath = [NSString stringWithString:iuMovie.posterPath];
        }
        else{
            thumbnailPath = [[NSBundle mainBundle] pathForResource:@"video_bg" ofType:@"png"];
        }
        [code addCodeLineWithFormat:@"<img src = \"%@\" width='100%%' height='100%%' style='position:absolute; left:0; top:0'>", thumbnailPath];
        
        NSString *videoPlayImagePath = [[NSBundle mainBundle] pathForResource:@"video_play" ofType:@"png"];
        [code addCodeLineWithFormat:@"<div style=\"background-image:url('%@'); \
         background-size:20%%;\
         background-repeat:no-repeat; \
         background-position:center; \
         position:absolute;  width:100%%; height:100%%; \"></div>", videoPlayImagePath];
        
        [code addCodeLine:@"</div>"];

        if( ((IUMovie *)iu).altText){
            [code addCodeLine:((IUMovie *)iu).altText];
        }
        [code addCodeLine:@"</video>"];
    }
#pragma mark IUWebMovie
    else if([iu isKindOfClass:[IUWebMovie class]]){
        IUWebMovie *iuWebMovie = (IUWebMovie *)iu;
        
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
        NSString *thumbnailPath;
        if(iuWebMovie.thumbnail){
            thumbnailPath = [NSString stringWithString:iuWebMovie.thumbnailPath];
        }
        else{
            thumbnailPath = [[NSBundle mainBundle] pathForResource:@"video_bg" ofType:@"png"];
        }
        
        [code addCodeLineWithFormat:@"<img src = \"%@\" width='100%%' height='100%%' style='position:absolute; left:0; top:0'>", thumbnailPath];
        
        NSString *videoPlayImagePath = [[NSBundle mainBundle] pathForResource:@"video_play" ofType:@"png"];
        [code addCodeLineWithFormat:@"<div style=\"background-image:url('%@'); \
         background-size:20%%;\
         background-repeat:no-repeat; \
         background-position:center; \
         position:absolute;  width:100%%; height:100%%; \"></div>", videoPlayImagePath];
        
        [code addCodeLine:@"</div>"];

    }
#pragma mark IUFBLike
    else if([iu isKindOfClass:[IUFBLike class]]){
        
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
        
        NSString *fbPath = [[NSBundle mainBundle] pathForResource:@"FBSampleImage" ofType:@"png"];
        NSString *editorHTML = [NSString stringWithFormat:@"<img src=\"%@\" align=\"middle\" style=\"float:left;margin:0 5px 0 0; \" ><p style=\"font-size:11px ; font-family:'Helvetica Neue', Helvetica, Arial, 'lucida grande',tahoma,verdana,arial,sans-serif\">263,929 people like this. Be the first of your friends.</p>", fbPath];
        [code addCodeLine:editorHTML];
        
        [code addCodeLine:@"</div>"];
    }
#pragma mark IUHTML
    else if([iu isKindOfClass:[IUHTML class]]){
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
        if(((IUHTML *)iu).hasInnerHTML){
            [code addCodeLine:((IUHTML *)iu).innerHTML];
        }
        if (iu.children.count) {
            
            for (IUBox *child in iu.children) {
                [code addCode:[self editorHTML:child]];
            }
        }
        [code addCodeLineWithFormat:@"</div>"];
        
    }
#pragma mark IUPageLinkSet
    else if ([iu isKindOfClass:[IUPageLinkSet class]]){
        [code addCodeLineWithFormat:@"<div %@>\n", [self HTMLAttributes:iu option:nil]];
        [code addCodeLineWithFormat:@"    <div class='IUPageLinkSetClip'>\n"];
        [code addCodeLineWithFormat:@"       <ul>\n"];
        [code addCodeLineWithFormat:@"           <a><li>1</li></a><a><li>2</li></a><a><li>3</li></a>"];
        [code addCodeLineWithFormat:@"       </div>"];
        [code addCodeLineWithFormat:@"    </div>"];
        [code addCodeLineWithFormat:@"</div"];
    }
#pragma mark IUText
    else if([iu isKindOfClass:[IUText class]]){
        IUText *textIU = (IUText *)iu;
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
        if (textIU.textHTML) {
            [code addCodeLineWithFormat:textIU.textHTML];
            
        }
        [code addCodeLineWithFormat:@"</div>"];
        
    }
#pragma mark IUTextFeild
    
    else if ([iu isKindOfClass:[IUTextField class]]){
        [code addCodeLineWithFormat:@"<input %@ >", [self HTMLAttributes:iu option:nil]];
    }
    
#pragma mark IUTextView

    else if ([iu isKindOfClass:[IUTextView class]]){
        NSString *inputValue = [[(IUTextView *)iu inputValue] length] ? [(IUTextView *)iu inputValue] : @"";
        [code addCodeLineWithFormat:@"<textarea %@ >%@</textarea>", [self HTMLAttributes:iu option:nil], inputValue];
    }

#pragma mark IUImport
    else if ([iu isKindOfClass:[IUImport class]]) {
        [code addCodeLineWithFormat:@"<div %@ >", [self HTMLAttributes:iu option:nil]];
        JDCode *importCode = [self editorHTML:[(IUImport*)iu prototypeClass]];
        NSString *codeString = [@" id=%@__" stringByAppendingString:iu.htmlID];
        [importCode replaceCodeString:@" id=" toCodeString:codeString];
        [code addCode:importCode];
        [code addCodeLine:@"</div>"];
    }
    
#pragma mark IUSubmitButton
    else if ([iu isKindOfClass:[IUSubmitButton class]]){
        [code addCodeLineWithFormat:@"<input %@ >", [self HTMLAttributes:iu option:nil]];
    }
    
#pragma mark IUBox
    else if ([iu isKindOfClass:[IUBox class]]) {
        [code addCode:[self editorHTMLAsBOX:iu]];
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


-(NSString*)CSSContentFromAttributes:(NSDictionary*)cssTagDictionary ofClass:(IUBox*)obj isHover:(BOOL)isHover isDefaultWidth:(BOOL)isDefaultWidth{
    //convert css tag dictionry to css string dictionary
    NSMutableDictionary *cssStringDict = [[self cssStringDictionaryWithCSSTagDictionary:cssTagDictionary ofClass:obj isHover:isHover] mutableCopy];
    
    if(isDefaultWidth == NO){
        [cssStringDict removeObjectForKey:@"position"];
    }
    
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
    
#pragma mark - 
#pragma mark mouseHover CSS
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
        
        if ([cssTagDict[IUCSSTagHoverBGColorEnable] boolValue]){
            value = cssTagDict[IUCSSTagHoverBGColor];
            if(value){
                NSColor *color = value;
                [dict putTag:@"background-color"  string:[color cssBGString]];
            }
        }
        
        if ([cssTagDict[IUCSSTagHoverTextColorEnable] boolValue]){
            value = cssTagDict[IUCSSTagHoverTextColor];
            if(value){
                [dict putTag:@"color" color:value ignoreClearColor:YES];
            }
        }
    }
#pragma mark -
#pragma mark normal CSS
    else {
        if (obj.flow) {
            [dict putTag:@"position" string:@"relative"];
        }
        if (obj.floatRight) {
            [dict putTag:@"position" string:@"relative"];
            [dict putTag:@"float" string:@"right"];
        }
        if ([obj isKindOfClass:[IUPageContent class]] || [obj isKindOfClass:[IUHeader class]]) {
            [dict putTag:@"position" string:@"relative"];
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
            if(value){
                if (obj.floatRight) {
                    [dict putTag:@"margin-right" floatValue:[value floatValue] * (-1) ignoreZero:NO unit:unit];
                }
                else if (obj.flow) {
                    [dict putTag:@"margin-left" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                }
                else {
                    [dict putTag:@"left" floatValue:[value floatValue] ignoreZero:NO unit:unit];
                }
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
            
            if(value){
                if (obj.flow) {
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
        if ([value boolValue]) {
            [dict putTag:@"visibility" string:@"hidden"];
        }
        
        
#pragma mark background-image and color
        value = cssTagDict[IUCSSTagBGColor];
        if(value){
            NSColor *color = value;
            [dict putTag:@"background-color" string:[color cssBGString]];
        }
        
        value = cssTagDict[IUCSSTagImage];
        if(value){
            if ([value isHTTPURL]) {
                [dict putTag:@"background-image" string:[NSString stringWithFormat:@"url(%@)",value]];
            }
            else {
                NSString *resourcePath = [_resourceSource relativePathForResource:value];
                [dict putTag:@"background-image" string:[resourcePath CSSURLString]];
            }
            
            IUBGSizeType bgSizeType = [cssTagDict[IUCSSTagBGSize] intValue];
            switch (bgSizeType) {
                case IUBGSizeTypeCenter:
                    [dict putTag:@"background-position" string:@"center"];
                    break;
                case IUBGSizeTypeStretch:
                    [dict putTag:@"background-size" string:@"100%% 100%%"];
                    break;
                case IUBGSizeTypeContain:
                    [dict putTag:@"background-size" string:@"contain"];
                    break;
                case IUBGSizeTypeCover:
                    [dict putTag:@"background-size" string:@"cover"];
                    break;
                default:
                    break;
            }
            
            id bgValue = cssTagDict[IUCSSTagBGXPosition];
            [dict putTag:@"background-position-x" intValue:[bgValue intValue] ignoreZero:YES unit:IUCSSUnitPixel];
            
            bgValue = cssTagDict[IUCSSTagBGYPosition];
            [dict putTag:@"background-position-y" intValue:[bgValue intValue] ignoreZero:YES unit:IUCSSUnitPixel];
            
            bgValue = cssTagDict[IUCSSTagBGRepeat];
            BOOL repeat = [bgValue boolValue];
            if(repeat){
                [dict putTag:@"background-repeat" string:@"repeat"];
            }
            else{
                [dict putTag:@"background-repeat" string:@"no-repeat"];
            }
        }
        else{
            BOOL enableGraident = [cssTagDict[IUCSSTagBGGradient] boolValue];
            NSColor *bgColor1 = cssTagDict[IUCSSTagBGGradientStartColor];
            NSColor *bgColor2 = cssTagDict[IUCSSTagBGGradientEndColor];
            
            if(enableGraident){
                if(bgColor2 == nil){
                    bgColor2 = [NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1];
                }
                if(bgColor1 == nil){
                    bgColor1 = [NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1];
                }
                [dict putTag:@"background-color" color:bgColor1 ignoreClearColor:YES];
                
                
                NSString    *webKitStr = [NSString stringWithFormat:@"-webkit-gradient(linear, left top, left bottom, color-stop(0.05, %@), color-stop(1, %@));", bgColor1.rgbString, bgColor2.rgbString];
                NSString    *mozStr = [NSString stringWithFormat:@"	background:-moz-linear-gradient( center top, %@ 5%%, %@ 100%% );", bgColor1.rgbString, bgColor2.rgbString];
                NSString    *ieStr = [NSString stringWithFormat:@"filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='%@', endColorstr='%@', GradientType=0)", bgColor1.rgbString, bgColor2.rgbString];
                NSString *gradientStr = [webKitStr stringByAppendingFormat:@"%@ %@", mozStr, ieStr];
                
                [dict putTag:@"background" string:gradientStr];
                
            }
            
        }
     
        
#pragma mark CSS - Border
        value = cssTagDict[IUCSSTagBorderLeftWidth];
        if ([value intValue] > 0) {
            [dict putTag:@"border-left-width" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];
            NSColor *color = cssTagDict[IUCSSTagBorderLeftColor];
            [dict putTag:@"border-left-color" color:color ignoreClearColor:NO];
        }
        value = cssTagDict[IUCSSTagBorderRightWidth];
        if ([value intValue] > 0) {
            [dict putTag:@"border-right-width" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];
            NSColor *color = cssTagDict[IUCSSTagBorderRightColor];
            [dict putTag:@"border-right-color" color:color ignoreClearColor:NO];
        }    value = cssTagDict[IUCSSTagBorderBottomWidth];
        if ([value intValue] > 0) {
            [dict putTag:@"border-bottom-width" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];
            NSColor *color = cssTagDict[IUCSSTagBorderBottomColor];
            [dict putTag:@"border-bottom-color" color:color ignoreClearColor:NO];
        }    value = cssTagDict[IUCSSTagBorderTopWidth];
        if ([value intValue] > 0) {
            [dict putTag:@"border-top-width" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];
            NSColor *color = cssTagDict[IUCSSTagBorderTopColor];
            [dict putTag:@"border-top-color" color:color ignoreClearColor:NO];
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
        
        value = cssTagDict[IUCSSTagOverflow];
        if ([value integerValue]) {
            [dict putTag:@"overflow" string:@"visible"];
        }
        
        NSInteger hOff = [cssTagDict[IUCSSTagShadowHorizontal] integerValue];
        NSInteger vOff = [cssTagDict[IUCSSTagShadowVertical] integerValue];
        NSInteger blur = [cssTagDict[IUCSSTagShadowBlur] integerValue];
        NSInteger spread = [cssTagDict[IUCSSTagShadowSpread] integerValue];
        NSColor *color = cssTagDict[IUCSSTagShadowColor];
        if (color == nil){
            color = [NSColor blackColor];
        }
        if (hOff || vOff || blur || spread){
            [dict putTag:@"box-shadow" string:[NSString stringWithFormat:@"%ldpx %ldpx %ldpx %ldpx %@", hOff, vOff, blur, spread, [color rgbString]]];
        }
        
        if([obj isKindOfClass:[IUText class]]|| [obj isKindOfClass:[IUTextField class]] || [obj isKindOfClass:[IUTextView class]] || [obj isKindOfClass:[IUPageLinkSet class]]){
            value = cssTagDict[IUCSSTagFontName];
            if(value){
                NSString *font=cssTagDict[IUCSSTagFontName];
                [dict putTag:@"font-family" string:[[LMFontController sharedFontController] cssForFontName:font]];
            }
            value = cssTagDict[IUCSSTagFontSize];
            if(value){
                [dict putTag:@"font-size" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];}
            value = cssTagDict[IUCSSTagFontColor];
            if(value){
                NSColor *color=cssTagDict[IUCSSTagFontColor];
                [dict putTag:@"color" color:color ignoreClearColor:YES];
            }
            
            value = cssTagDict[IUCSSTagLineHeight];
            if(value){
                if([value isEqualToString:@"Auto"]== YES)
                {
                    if([obj isKindOfClass:[IUText class]]){
                        NSNumber *height = cssTagDict[IUCSSTagHeight];
                        NSUInteger num = [[((IUText *)obj).textHTML componentsSeparatedByString:@"<br>"] count];
              
                        if(num > 0){
                            num--;
                        }
                        if(num == 0){
                            [dict putTag:@"line-height" floatValue:[height floatValue] ignoreZero:YES unit: IUCSSUnitPixel];
                        }
                        else{
                            [dict putTag:@"line-height" floatValue:[height floatValue]/num ignoreZero:YES unit: IUCSSUnitPixel];
                        }
                    }
                    else if ([obj isKindOfClass:[IUTextView class]]){
                        [dict putTag:@"line-height" floatValue:1.3 ignoreZero:YES unit:IUCSSUnitNone];

                    }
                }
                else {
                    [dict putTag:@"line-height" floatValue:[value floatValue] ignoreZero:YES unit:IUCSSUnitNone];
                }
            }
            
            BOOL boolValue =[cssTagDict[IUCSSTagFontWeight] boolValue];
            if(boolValue){
                [dict putTag:@"font-weight" string:@"bold"];
            }
            boolValue = [cssTagDict[IUCSSTagFontStyle] boolValue];
            if(boolValue){
                [dict putTag:@"font-style" string:@"italic"];
            }
            boolValue = [cssTagDict[IUCSSTagTextDecoration] boolValue];
            if(boolValue){
                [dict putTag:@"text-decoration" string:@"underline"];
            }
            
            id value = cssTagDict[IUCSSTagTextAlign];
            if (value) {
                NSInteger align = [value integerValue];
                NSString *alignText;
                switch (align) {
                    case IUAlignLeft:
                        alignText = @"left";
                        break;
                    case IUAlignCenter:
                        alignText = @"center";
                        break;
                    case IUAlignRight:
                        alignText = @"right";
                        break;
                    case IUAlignJustify:
                        alignText = @"stretch";
                        break;
                    default:
                        JDErrorLog(@"no align type");
                }
                [dict putTag:@"text-align" string:alignText];
            }
        }
        /*
        else{
            [dict putTag:@"line-height" string:@"initial"];
        }
         */


    }
    //end of else (not hover)
    return dict;

}

- (BOOL)isLastCharacterBRElement:(NSString *)text{
    NSArray *textArray = [text componentsSeparatedByString:@"<br>"];
    NSString *lastString =  [[textArray lastObject] stringByTrim];
    if([lastString isEqualToString:@"</span>"]){
        return YES;
    }
    return NO;
}


-(NSString *)fontCSSContentFromAttributes:(NSDictionary*)attributeDict{
    NSMutableString *retStr = [NSMutableString string];
    NSString *fontName = attributeDict[IUCSSTagFontName];
    if (fontName) {
        [retStr appendFormat:@"font-family : %@;", [[LMFontController sharedFontController] cssForFontName:fontName]];
    }
    NSNumber *fontSize = attributeDict[IUCSSTagFontSize];
    if (fontSize) {
        [retStr appendFormat:@"font-size : %dpx;", [fontSize intValue]];
    }
    NSColor *fontColor = attributeDict[IUCSSTagFontColor];
    if (fontColor){
        [retStr appendFormat:@"color:%@;", [fontColor rgbString]];
    }
    BOOL boolValue =[attributeDict[IUCSSTagFontWeight] boolValue];
    if(boolValue){
        [retStr appendString:@"font-weight:bold;"];
    }
    boolValue = [attributeDict[IUCSSTagFontStyle] boolValue];
    if(boolValue){
        [retStr appendString:@"font-style:italic;"];
    }
    boolValue = [attributeDict[IUCSSTagTextDecoration] boolValue];
    if(boolValue){
        [retStr appendString:@"text-decoration:underline;"];
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

- (NSString*)HTMLAttributes:(IUBox*)iu option:(NSDictionary*)option{
    NSMutableString *retString = [NSMutableString string];
    [retString appendFormat:@"id=%@", iu.htmlID];
    
    NSArray *classPedigree = [[iu class] classPedigreeTo:[IUBox class]];
    NSMutableString *className = [NSMutableString string];
    for (NSString *str in classPedigree) {
        [className appendString:str];
        [className appendString:@" "];
    }
    [className appendFormat:@" %@", iu.htmlID];
    [className trim];
    [retString appendFormat:@" class='%@'", className];
    
    if(iu.center){
        [retString appendString:@" horizontalCenter='1'"];
    }
    if (iu.opacityMove) {
        [retString appendFormat:@" opacityMove='%.1f'", iu.opacityMove];
    }
    if (iu.xPosMove) {
        [retString appendFormat:@" xPosMove='%.1f'", iu.xPosMove];
    }
#pragma mark IUImage
    if ([iu isKindOfClass:[IUImage class]]) {
        IUImage *iuImage = (IUImage*)iu;
        if (iuImage.variable && _rule == IUCompileRuleDjango) {
            if ([iu.document isKindOfClass:[IUClass class]]) {
                [retString appendFormat:@" src={{ object.%@ }}", iuImage.variable];
            }
            else {
                [retString appendFormat:@" src={{ %@ }}>", iuImage.variable];
            }
        }else{
            //image tag attributes
            if(iuImage.imageName){
                NSString *imagePath = [_resourceSource relativePathForResource:iuImage.imageName];
                [retString appendFormat:@" src='%@'", imagePath];
            }
            if(iuImage.altText){
                [retString appendFormat:@" alt='%@'", iuImage.altText];
            }
        }
    }
#pragma mark IUWebMovie
    else if([iu isKindOfClass:[IUWebMovie class]]){
        IUWebMovie *iuWebMovie = (IUWebMovie *)iu;
        if(iuWebMovie.eventautoplay){
            [retString appendString:@" eventAutoplay='1'"];
            [retString appendFormat:@" videoid='%@'", iuWebMovie.thumbnailID];
            [retString appendFormat:@" videotype='%@'", iuWebMovie.type];
        }
    }
#pragma mark IUMovie
    else if ([iu isKindOfClass:[IUMovie class]]) {
        if(option){
            BOOL editor = [[option objectForKey:@"editor"] boolValue];
            if(editor == NO){
                IUMovie *iuMovie = (IUMovie*)iu;
                if (iuMovie.enableControl) {
                    [retString appendString:@" controls"];
                }
                if (iuMovie.enableLoop) {
                    [retString appendString:@" loop"];
                }
                if (iuMovie.enableMute) {
                    [retString appendString:@" muted"];
                }
                if (iuMovie.enableAutoPlay) {
                    [retString appendString:@" autoplay"];
                }
                if (iuMovie.posterPath) {
                    [retString appendFormat:@" poster=%@", iuMovie.posterPath];
                }
            }
        }
    }
#pragma mark IUCarouselItem
    else if([iu isKindOfClass:[IUCarouselItem class]]){
        [retString appendFormat:@" carouselID=%@", iu.parent.htmlID];
    }
#pragma mark IUCollection
    else if ([iu isKindOfClass:[IUCollection class]]){
        IUCollection *iuCollection = (IUCollection*)iu;

        NSData *data = [NSJSONSerialization dataWithJSONObject:iuCollection.responsiveSetting options:0 error:nil];
        [retString appendFormat:@" responsive=%@ defaultItemCount=%ld",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], iuCollection.defaultItemCount];
    }
#pragma mark IUTextField
    else if ([iu isKindOfClass:[IUTextField class]]){
        IUTextField *iuTextField = (IUTextField *)iu;
        if(iuTextField.formName){
            [retString appendFormat:@" name=\"%@\"",iuTextField.formName];
        }
        if(iuTextField.placeholder){
            [retString appendFormat:@" placeholder=\"%@\"",iuTextField.placeholder];
        }
        if(iuTextField.inputValue){
            [retString appendFormat:@" value=\"%@\"",iuTextField.inputValue];
        }
        if(iuTextField.type == IUTextFieldTypePassword){
            [retString appendFormat:@" type=\"password\""];
        }
        else {
            [retString appendString:@" type=\"text\""];
        }
    }
#pragma mark IUSubmitButton
    else if ([iu isKindOfClass:[IUSubmitButton class]]){
        [retString appendString:@" type=\"submit\" value=\"JOIN\""];
    }
#pragma mark IUForm
    else if ([iu isKindOfClass:[IUForm class]]){
        [retString appendString:@" method=\"post\" action=\"#\""];
    }
#pragma mark IUTextView
    else if([iu isKindOfClass:[IUTextView class]]){
        IUTextView *iuTextView = (IUTextView *)iu;
        if(iuTextView.placeholder){
            [retString appendFormat:@" placeholder=\"%@\"",iuTextView.placeholder];
        }
        if(iuTextView.formName){
            [retString appendFormat:@" name=\"%@\"",iuTextView.formName];
        }
    }
#pragma mark IUTransition
    else if ([iu isKindOfClass:[IUTransition class]]){
        IUTransition *transitionIU = (IUTransition*)iu;
        if ([transitionIU.eventType length]) {
            if ([transitionIU.eventType isEqualToString:kIUTransitionEventClick]) {
                [retString appendFormat:@" transitionEvent=\"click\""];
            }
            else if ([transitionIU.eventType isEqualToString:kIUTransitionEventMouseOn]){
                [retString appendFormat:@" transitionEvent=\"mouseOn\""];
            }
            else {
                assert(0);
            }
        }
        if ([transitionIU.animation length]) {
            if ([transitionIU.animation isEqualToString:kIUTransitionAnimationFlyFromRight]) {
                [retString appendFormat:@" transitionAnimation=\"flyFromRight\""];
            }
            else if ([transitionIU.animation isEqualToString:kIUTransitionAnimationOverlap]){
                [retString appendFormat:@" transitionAnimation=\"overlap\""];
            }
            else {
                assert(0);
            }
        }
    }

    return retString;
}


#pragma mark manage JS source

-(NSString *)outputJSArgs:(IUBox *)iu{
    NSMutableString *argStr = [NSMutableString string];
    
    if([iu isKindOfClass:[IUCarousel class]]){
        IUCarousel *carouselIU = (IUCarousel *)iu;
        [argStr appendString:@"{"];
        if(carouselIU.autoplay){
            [argStr appendString:@"auto:true, "];
        }
        else{
            [argStr appendString:@"auto:false, "];
        }
        if(carouselIU.disableArrowControl){
            [argStr appendString:@"controls:false, "];
        }
        else{
            [argStr appendString:@"controls:true, "];
        }
        switch (carouselIU.controlType) {
            case IUCarouselControlTypeNone:
                [argStr appendString:@"pager:false"];
                break;
            case IUCarouselControlBottom:
                [argStr appendString:@"autoControls:false"];
                break;
        }
        [argStr appendString:@"}"];
    }
    
    return argStr;
}

-(NSString*)outputJSInitializeSource:(IUDocument *)document{
    NSString *jsSource = [[self outputJSSource:document] stringByIndent:8 prependIndent:YES];
    return jsSource;
}

-(NSString *)outputJSSource:(IUBox *)iu{
    NSMutableString *code = [NSMutableString string];
   
    if([iu isKindOfClass:[IUCarousel class]]){
        [code appendString:@"/* IUCarousel initialize */\n"];
        [code appendFormat:@"$('#bxslider_%@').bxSlider(%@)", iu.htmlID, [self outputJSArgs:iu]];
        [code appendNewline];
    }
    else if ([iu isKindOfClass:[IUBox class]]) {
        if (iu.children.count) {
            [code appendNewline];
            for (IUBox *child in iu.children) {
                [code appendString:[self outputJSSource:child]];
                [code appendNewline];
            }
        }

    }
    
    return code;
}

@end
