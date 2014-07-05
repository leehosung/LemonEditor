//
//  LMCanvasViewController.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMCanvasVC.h"

#import "LMWC.h"
#import "LMWindow.h"
#import "JDLogUtil.h"
#import "SizeView.h"
#import "IUFrameDictionary.h"
#import "IUBox.h"
#import "IUCarousel.h"
#import "IUCarouselItem.h"
#import "InnerSizeBox.h"
#import "IUSection.h"
#import "IUImport.h"
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
#import "IUText.h"
#endif

#import "LMHelpWC.h"

#pragma mark - debug
#if DEBUG
#import "LMDebugSourceWC.h"

#endif

#import "IUPage.h"
#import "IUBackground.h"

@interface LMCanvasVC ()

#pragma mark - debug window
@property (weak) IBOutlet NSButton *debugBtn;
#if DEBUG
@property LMDebugSourceWC *debugWC;

#endif

@end

@implementation LMCanvasVC{
    IUFrameDictionary *frameDict;
    LMHelpWC *helpWC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        frameDict = [[IUFrameDictionary alloc] init];;
        _maxFrameWidth = 0;
    }
    return self;
}

-(void)awakeFromNib{
    
    [self addObserver:self forKeyPath:@"view.sizeView.sizeArray" options:NSKeyValueObservingOptionInitial context:@"mqCount"];
    [self addObserver:self forKeyPaths:@[@"sheet.ghostImageName",
                                         @"sheet.ghostX",
                                         @"sheet.ghostY",
                                         @"sheet.ghostOpacity"]
              options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:@"ghostImage"];
    
    
#if DEBUG
    
    _debugWC = [[LMDebugSourceWC alloc] initWithWindowNibName:@"LMDebugSourceWC"];
    _debugWC.canvasVC = self;
    [_debugBtn setHidden:NO];
#else
    [_debugBtn setHidden:YES];
#endif
}
-(void) dealloc{
    //release 시점 확인용
    NSAssert(0, @"");
    /*
    [self removeObserver:self forKeyPath:@"view.sizeView.sizeArray" ];
    [self removeObserver:self forKeyPaths:@[@"sheet.ghostImageName",
                                         @"sheet.ghostX",
                                         @"sheet.ghostY",
                                         @"sheet.ghostOpacity"]];
     */
}

-(void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selectedObjects" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:nil];
}


-(LMCanvasView*)view{
    return (LMCanvasView*)[super view];
}

-(void)changeIUPageHeight:(CGFloat)pageHeight{
    [(LMCanvasView*)self.view setHeightOfMainView:pageHeight];
}

- (void)addFrame:(NSInteger)frameSize{
    [[self sizeView] addFrame:frameSize];
}


#pragma mark -
#pragma mark call by sizeView


- (SizeView *)sizeView{
    return ((LMCanvasView *)(self.view)).sizeView;
    
}

#pragma mark -
#pragma mark call by webView

- (WebCanvasView *)webView{
    return ((LMCanvasView *)self.view).webView;
}

- (DOMDocument *)DOMDoc{
    return [[[self webView] mainFrame] DOMDocument];
}



- (BOOL)makeNewIUByDragAndDrop:(IUBox *)newIU atPoint:(NSPoint)point atIU:(NSString *)parentIUID{
    IUBox *parentIU = [self.controller IUBoxByIdentifier:parentIUID];
    if ([parentIUID containsString:@"ImportedBy_"]) {
        NSString *realID = [[parentIUID componentsSeparatedByString:@"_"] objectAtIndex:2];
        parentIU = [self.controller IUBoxByIdentifier:realID];
    }
    
    
    //find parent IU
    if([parentIU isKindOfClass:[IUPage class]]){
        parentIU = (IUBox *)((IUPage *)parentIU).pageContent;
    }
    
    int i=0;
    while([parentIU shouldAddIUByUserInput] == NO){
        
        if([parentIU isKindOfClass:[IUBackground class]]){
            return NO;
        }
        
        //safe code;
        if(i>10000){
            [JDUIUtil hudAlert:@"Can't find parent node, you try it, again" second:2];
            return NO;
        }
        
        parentIU = parentIU.parent;
    }
  
    NSPoint position = [self distanceFromIU:parentIUID toPointFromWebView:point];
        
    //postion을 먼저 정한 후에 add 함
    [newIU setPosition:position];
    [parentIU addIU:newIU error:nil];
    [self.controller rearrangeObjects];
    [self.controller setSelectedObjectsByIdentifiers:@[newIU.htmlID]];
    
    [newIU confirm];
    
    JDTraceLog( @"[IU:%@] : point(%.1f, %.1f) atIU:%@", newIU.htmlID, point.x, point.y, parentIUID);
    return YES;
}

- (void)removeSelectedIUs{
    for(IUBox *obj in self.controller.selectedObjects){
        if([obj shouldRemoveIUByUserInput]){
            [obj.parent removeIU:obj];
        }
    }
    [self.controller rearrangeObjects];
}

-(void)insertImage:(NSString *)name atIU:(NSString *)identifier{
    IUBox *currentIU = [self.controller IUBoxByIdentifier:identifier];
    [currentIU setImageName:name];
}

#pragma mark -
#pragma mark call by Document


- (void)updateSheetHeight{
    //not page class
    //page will be set report from javscript
    if([_sheet isKindOfClass:[IUClass class]]){
        CGFloat currentHeight =  [[_sheet.css assembledTagDictionary][IUCSSTagHeight] floatValue];
        [(LMCanvasView *)self.view setHeightOfMainView:currentHeight];
    }
    else if([_sheet isKindOfClass:[IUBackground class]]){
        IUBackground *background = (IUBackground *)_sheet;
        CGFloat currentHeight = [[background.header.css assembledTagDictionary][IUCSSTagHeight] floatValue];
        [(LMCanvasView *)self.view setHeightOfMainView:currentHeight];
    }
    
}

- (void)setSheet:(IUSheet *)sheet{
    NSAssert(self.documentBasePath != nil, @"resourcePath is nil");
    if (self.documentBasePath == nil) {
        return;
    }
    JDSectionInfoLog( IULogSource, @"resourcePath  : %@", self.documentBasePath);
    [[self gridView] clearAllLayer];
    [_sheet setDelegate:nil];
    _sheet = sheet;
    [_sheet setDelegate:self];
    
    [[[self webView] mainFrame] loadHTMLString:sheet.editorSource baseURL:[NSURL fileURLWithPath:self.documentBasePath]];
    
    
    [self updateSheetHeight];
}

- (void)reloadSheet{
    [self setSheet:_sheet];
//    [[[self webView] mainFrame] reload];
}

- (void)ghostImageContextDidChange:(NSDictionary *)change{
    NSString *ghostImageName = _sheet.ghostImageName;
    IUResourceFile *resourceNode = [_resourceManager resourceFileWithName:ghostImageName];
    NSImage *ghostImage = [[NSImage alloc] initWithContentsOfFile:resourceNode.absolutePath];
    
    [[self gridView] setGhostImage:ghostImage];
    
    NSPoint ghostPosition = NSMakePoint(_sheet.ghostX, _sheet.ghostY);
    [[self gridView] setGhostPosition:ghostPosition];
    
    [[self gridView] setGhostOpacity:_sheet.ghostOpacity];
}


#pragma mark -
#pragma mark manage IUs
-(NSUInteger)countOfSelectedIUs{
    return [self.controller.selectedObjects count];
}
- (BOOL)containsIU:(NSString *)IUID{
    if ([self.controller.selectedIdentifiers containsObject:IUID]){
        return YES;
    }
    else {
        return NO;
    }
}
- (BOOL)isEditable{
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
    if([self countOfSelectedIUs] == 1){
        IUBox *currentIU = self.controller.selectedObjects[0];
        if([currentIU isKindOfClass:[IUText class]]){
            return YES;
        }
    }
#endif
    return NO;
}

- (NSString *)selectedIUIdentifier{
    if([self countOfSelectedIUs] == 1){
        IUBox *currentIU = self.controller.selectedObjects[0];
        return currentIU.htmlID;
    }
    return nil;
}


-(void)selectedObjectsDidChange:(NSDictionary*)change{
    [JDLogUtil log:IULogAction key:@"CanvasVC:observed" string:[self.controller.selectedIdentifiers description]];
    
    [[self gridView] removeAllSelectionLayers];
    [[self gridView] removeAllTextPointLayer];
    

    for(IUBox *box in self.controller.selectedObjects){
        if([box isKindOfClass:[IUCarouselItem class]]){
            NSInteger index = [box.parent.children indexOfObject:box];
            [[self webView] selectCarousel:box.parent.htmlID atIndex:index];
        }
    }
    
    for(NSString *IUID in self.controller.selectedIdentifiersWithImportIdentifier){
        if([frameDict.dict objectForKey:IUID]){
            NSRect frame = [[frameDict.dict objectForKey:IUID] rectValue];
            [[self gridView] addSelectionLayerWithIdentifier:IUID withFrame:frame];
            [[self gridView] addTextPointLayer:IUID withFrame:frame];
            [[self webView] changeDOMRange:frame.origin];
        }
    }
    
}
- (void)deselectedAllIUs{
    [self.controller setSelectionIndexPath:nil];
}
- (void)addSelectedIU:(NSString *)IU{
    if(IU == nil){
        return;
    }
    if([self.controller.selectedIdentifiers containsObject:IU]){
        return;
    }
    NSArray *array = [self.controller.selectedIdentifiers arrayByAddingObject:IU];
    [self.controller trySetSelectedObjectsByIdentifiers:array];
}

- (void)removeSelectedIU:(NSString *)IU{
    if(IU == nil){
        return;
    }
    if([self.controller.selectedIdentifiers containsObject:IU] == NO){
        return;
    }
    
    NSMutableArray *selectArray = [self.controller.selectedIdentifiers mutableCopy];
    [selectArray removeObject:IU];
    [self.controller trySetSelectedObjectsByIdentifiers:selectArray];
}

- (void)setSelectedIU:(NSString *)identifier{
    if(identifier == nil){
        return;
    }
    
    NSString *selectedID = identifier;
    
    IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
    if([iu isKindOfClass:[IUItem class]]){
        IUBox *parentIU = iu.parent;
        if([self.controller.selectedIdentifiers containsString:parentIU.htmlID] == NO &&
           [self.controller.selectedIdentifiers containsString:identifier] == NO){
            selectedID = parentIU.htmlID;
        }
    }
    
    NSArray *addArray = [NSArray arrayWithObject:selectedID];
    
    /*
     Even it is selected object, still select it again.
     (IUClass is not shown selected until it is selected again)
     */
    [self.controller trySetSelectedObjectsByIdentifiers:addArray];

}

- (void)selectIUInRect:(NSRect)frame{
    NSArray *keys = [frameDict.dict allKeys];
    
    [self deselectedAllIUs];
    
    for(NSString *key in keys){
        NSRect iuframe = [[frameDict.dict objectForKey:key] rectValue];
        if( NSIntersectsRect(iuframe, frame) ){
            [self addSelectedIU:key];
        }
    }
}

#pragma mark setText

#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION

- (void)updateNewline:(NSRange)range identifier:(NSString *)identifier htmlNode:(DOMHTMLElement *)node{
    
    IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
    NSAssert(iu != nil);
    if([iu isKindOfClass:[IUText class]]){
        IUText *textIU = (IUText *)iu;
        [textIU updateNewLine:range htmlNode:node];
    }
}
 

- (void)selectTextRange:(NSRange)range identifier:(NSString *)identifier htmlNode:(DOMHTMLElement *)node{

    IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
    NSAssert(iu != nil);
    if([iu isKindOfClass:[IUText class]]){
        IUText *textIU = (IUText *)iu;
        [textIU selectTextRange:range htmlNode:node];
    }

}
#endif

/*
//text
- (void)selectTextRange:(NSRange)range identifier:(NSString *)identifier{
    self.controller.selectedTextRange = range;
}

- (void)insertString:(NSString *)string identifier:(NSString *)identifier withRange:(NSRange)range{
    [JDLogUtil log:IULogText string:[NSString stringWithFormat:@"insert - %@ , (%lu, %lu)", string, range.location, range.length]];
    IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
    NSAssert(iu != nil);
    [iu insertText:string withRange:range];
}

- (void)deleteStringRange:(NSRange)range identifier:(NSString *)identifier{
    [JDLogUtil log:IULogText string:[NSString stringWithFormat:@"delete (%lu, %lu)", range.location, range.length]];
    IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
    [iu deleteTextInRange:range];
}
 */

#pragma mark -
#pragma mark IUDelegate

- (id)callWebScriptMethod:(NSString *)function withArguments:(NSArray *)args{
    return [[self webView] callWebScriptMethod:function withArguments:args];
}

- (NSPoint)distanceFromIU:(NSString *)parentName to:(NSString *)iuName{
    NSRect iuFrame = [[frameDict.dict objectForKey:iuName] rectValue];
    NSRect parentFrame = [[frameDict.dict objectForKey:parentName] rectValue];
    
    NSPoint distance = NSMakePoint(iuFrame.origin.x-parentFrame.origin.x,
                                   iuFrame.origin.y - parentFrame.origin.y);
    return distance;
}

- (NSSize)frameSize:(NSString *)identifier{
    NSRect iuFrame = [[frameDict.dict objectForKey:identifier] rectValue];
    return iuFrame.size;
}

- (NSPoint)distanceFromIU:(NSString*)parentName toPointFromWebView:(NSPoint)point{
    
    NSRect parentFrame = [[frameDict.dict objectForKey:parentName] rectValue];
    
    NSPoint distance = NSMakePoint(point.x-parentFrame.origin.x,
                                   point.y - parentFrame.origin.y);
    return distance;
}

#pragma mark -
#pragma mark link attributes

-(void)IURemoveLink:(NSString *)identifier{
    /*
     
     => IUView
     IUParent-IUNode
     => DOMNode View
     IUParent - LINKNode - IUNode
             (remove link)
     */
    DOMHTMLElement *selectHTMLElement = [self getHTMLElementbyID:identifier];
    DOMNode *linkNode = selectHTMLElement.parentNode;
    if([linkNode isKindOfClass:[DOMHTMLAnchorElement class]] == NO){
        JDWarnLog(@"[IU:%@] don't have link", identifier);
        return;
    }
    //replace nodes
    DOMNode *linkParentNode = linkNode.parentNode;
    [linkParentNode replaceChild:selectHTMLElement oldChild:linkNode];
    
}

-(void)IUClassIdentifier:(NSString *)classIdentifier addClass:(NSString *)className{
    DOMNodeList *list = [self.DOMDoc.documentElement getElementsByClassName:classIdentifier];
    for (int i=0; i<list.length; i++) {
        DOMHTMLElement *node = (DOMHTMLElement*)[list item:i];
        NSString *currentClass = [node getAttribute:@"class"];
        [node setAttribute:@"class" value:[currentClass stringByAppendingFormat:@" %@", className]];
    }
}

-(void)IUClassIdentifier:(NSString *)classIdentifier removeClass:(NSString *)className{
    DOMNodeList *list = [self.DOMDoc.documentElement getElementsByClassName:classIdentifier];
    for (int i=0; i<list.length; i++) {
        DOMHTMLElement *node = (DOMHTMLElement*)[list item:i];
        NSString *currentClass = [node getAttribute:@"class"];
        [node setAttribute:@"class" value:[currentClass stringByReplacingOccurrencesOfString:className withString:@""]];
    }
}

-(void)updateTextRangeFromID:(NSString *)fromID toID:(NSString *)toID{    
    [self.webView selectTextFromID:fromID toID:toID];
}


#pragma mark -
#pragma mark HTML

- (DOMHTMLElement *)getHTMLElementbyID:(NSString *)HTMLID{
    DOMHTMLElement *selectNode = (DOMHTMLElement *)[self.DOMDoc getElementById:HTMLID];
    return selectNode;
    
}

- (NSString *)tagWithHTML:(NSString *)html{
   NSString *incompleteTag = [html componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]][0];
    NSString *tag = [incompleteTag componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]][1];
    if(tag.length == 0){
        JDErrorLog(@"Can't find tag");
    }
    return tag;
}

-(void)IUHTMLIdentifier:(NSString*)identifier textHTML:(NSString *)html withParentID:(NSString *)parentID nearestID:(NSString *)nID index:(NSUInteger)index{
    
    [self IUHTMLIdentifier:identifier HTML:html withParentID:parentID];
    [[self webView] selectTextRange:[self getHTMLElementbyID:nID] index:index];

}


-(void)IUHTMLIdentifier:(NSString*)identifier HTML:(NSString *)html withParentID:(NSString *)parentID{

    DOMHTMLElement *currentElement = [self getHTMLElementbyID:identifier];
    if(currentElement){
        //change html text
        [currentElement setOuterHTML:html];
    }
    else{
        //insert html
        DOMHTMLElement *selectHTMLElement = [self getHTMLElementbyID:parentID];
        if (selectHTMLElement == nil) {
            return;
        }
        DOMHTMLElement *newElement = (DOMHTMLElement *)[self.DOMDoc createElement:[self tagWithHTML:html]];
        [selectHTMLElement appendChild:newElement];
        
        [newElement setOuterHTML:html];
        

    }
    IUBox *iu = [_controller IUBoxByIdentifier:identifier];
    if([iu isKindOfClass:[IUCarousel class]]){
        [[self webView] insertNewCarousel:identifier];
        [self.controller rearrangeObjects];
        [self.controller setSelectedObjectsByIdentifiers:@[identifier]];
    }
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
    else if([iu isKindOfClass:[IUText class]]){
        [(IUText *)iu updateAutoHeight];
    }
#endif
    
//    JDDebugLog(@"%@:%@", identifier, html);

}


- (void)runJSAfterInsertIU:(IUBox *)iu{
    [[self webView] runJSAfterRefreshCSS];
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
    if([iu isMemberOfClass:[IUBox class]]){
        [iu updateAutoHeight];
    }
#endif
    [self.webView setNeedsDisplay:YES];
}

- (void)runCSSJS{
    [[self webView] runJSAfterRefreshCSS];
}


#pragma mark -
#pragma mark CSS

-(void)IUClassIdentifier:(NSString *)identifier CSSRemovedforWidth:(NSInteger)width{
    if(width == IUCSSMaxViewPortWidth){
        //default setting
        [self removeCSSTextWithIDInDefault:identifier];
    }
    else{
        [self removeCSSTextWithID:identifier size:width];
        
    }
    [self.webView setNeedsDisplay:YES];
    
}

- (BOOL)isSheetHeightChanged:(NSString *)identifier{
    if([identifier isEqualToString:[@"." stringByAppendingString:_sheet.htmlID]]
       && [_sheet isKindOfClass:[IUClass class]]){
        return YES;
    }
    else if([_sheet isKindOfClass:[IUBackground class]]){
        IUHeader *header = ((IUBackground *)_sheet).header;
        if([identifier isEqualToString:[@"." stringByAppendingString:header.htmlID]]){
            return YES;
        }
        
    }
    
    return NO;
}


-(void)IUClassIdentifier:(NSString*)identifier CSSUpdated:(NSString*)css forWidth:(NSInteger)width{
    [JDLogUtil log:IULogSource key:@"css source" string:css];
    
    if(css.length == 0){
        //nothing to do
        [self IUClassIdentifier:identifier CSSRemovedforWidth:width];
    }else{
        
        NSString *cssText = [NSString stringWithFormat:@"%@{%@}", identifier, css];
        if(width == IUCSSMaxViewPortWidth){
            //default setting
            [self setIUStyle:cssText withID:identifier];
        }
        else{
            [self setIUStyle:cssText withID:identifier size:width];
            
        }
//        [self.webView setNeedsDisplay:YES];
    }
    
    if([self isSheetHeightChanged:identifier]){
        //CLASS에서 WEBCANVASVIEW의 높이 변화를 위해서
        [self updateSheetHeight];
    }
    
}



- (void)removeStyleSheet:(NSInteger)size{
    DOMElement *cssNode = [[self DOMDoc] getElementById:[NSString stringWithFormat:@"style%ld", size]];
    [cssNode.parentNode removeChild:cssNode];

}

- (id)makeNewStyleSheet:(NSInteger)size{
    
    DOMElement *newSheet = [[self DOMDoc] createElement:@"style"];
    NSString *mediaName = [NSString stringWithFormat:@"screen and (max-width:%ldpx)", size];
    [newSheet setAttribute:@"type" value:@"text/css"];
    [newSheet setAttribute:@"media" value:mediaName];
    [newSheet setAttribute:@"id" value:[NSString stringWithFormat:@"style%ld", size]];
    [newSheet appendChild:[[self DOMDoc] createTextNode:@""]];
    
    DOMNode *headNode = [[[self DOMDoc] getElementsByTagName:@"head"] item:0];
    NSInteger nextSize = [[self sizeView] nextSmallSize:size];
    DOMElement *prevNode = [[self DOMDoc] getElementById:[NSString stringWithFormat:@"style%ld", nextSize]];

    if(nextSize == 0
       || prevNode == nil){
        //case 1) default style and import style(reset.css, iu.css)
        //case 2) add maximum size
        //case 3) not yet report smaller size
            [headNode appendChild:newSheet];
    }
    else{
        //find next node
        [headNode insertBefore:newSheet refChild:prevNode];
    }

    return newSheet;
}

- (void)setIUStyle:(NSString *)cssText withID:(NSString *)iuID{
    DOMHTMLStyleElement *sheetElement = (DOMHTMLStyleElement *)[[self DOMDoc] getElementById:@"default"];
    [self setCSSRuleInStyleSheet:sheetElement cssText:cssText withID:iuID];
    
}
- (void)setIUStyle:(NSString *)cssText withID:(NSString *)iuID size:(NSInteger)size{
    DOMHTMLStyleElement *sheetElement = (DOMHTMLStyleElement *)[[self DOMDoc] getElementById:[NSString stringWithFormat:@"style%ld", size]];
    if(sheetElement == nil){
        sheetElement = [self makeNewStyleSheet:size];
    }
    [self setCSSRuleInStyleSheet:sheetElement cssText:cssText withID:iuID];;
}

- (void)setCSSRuleInStyleSheet:(DOMHTMLStyleElement *)styleSheet cssText:(NSString *)cssText withID:(NSString *)iuID{

    NSString *newCSSText = [self innerCSSText:styleSheet.innerHTML byAddingCSSText:cssText withID:iuID];
    [styleSheet setInnerHTML:newCSSText];
    [[self webView] runJSAfterRefreshCSS];
}


-(NSString *)cssIDInCSSRule:(NSString *)cssrule{

    NSString *css = [cssrule stringByTrim];
    NSArray *cssItems = [css componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    
    return [cssItems[0] stringByTrim];
}

- (NSString *)innerCSSText:(NSString *)innerCSSText byAddingCSSText:(NSString *)cssText withID:(NSString *)identifier
{
    NSMutableString *innerCSSHTML = [NSMutableString stringWithString:@"\n"];
    NSString *trimmedInnerCSSHTML = [innerCSSText  stringByTrim];
    NSArray *cssRuleList = [trimmedInnerCSSHTML componentsSeparatedByString:@"\n"];

//    NSArray *cssRuleList = [trimmedInnerCSSHTML componentsSeparatedByCharactersInSet:
  //                          [NSCharacterSet characterSetWithCharactersInString:@"."]];

    for(NSString *rule in cssRuleList){
        if(rule.length == 0){
            continue;
        }
         NSString *ruleID = [self cssIDInCSSRule:rule];
        NSString *modifyidentifier = [identifier stringByTrim];
        if([ruleID isEqualToString:modifyidentifier] == NO){
            [innerCSSHTML appendString:[NSString stringWithFormat:@"\t%@\n", [rule stringByTrim]]];
        }
    }
    
    [innerCSSHTML appendString:cssText];
    [innerCSSHTML appendString:@"\n"];
    
    return innerCSSHTML;
}

-(void)removeAllCSSWithIdentifier:(NSString *)identifier{
    DOMNodeList *styleList = [[self DOMDoc] getElementsByTagName:@"style"];
    //0 번째는 import sheet라서 건너뜀.
    for(int i=0; i<styleList.length; i++){
        DOMHTMLStyleElement *styleElement = (DOMHTMLStyleElement *)[styleList item:i];
        [self removeCSSRuleInStyleSheet:styleElement withID:identifier];
    }
    
}

- (void)removeCSSTextWithIDInDefault:(NSString *)iuID{
    DOMHTMLStyleElement *sheetElement = (DOMHTMLStyleElement *)[[self DOMDoc] getElementById:@"default"];
    [self removeCSSRuleInStyleSheet:sheetElement withID:iuID];
    
}
- (void)removeCSSTextWithID:(NSString *)iuID size:(NSInteger)size{
    DOMHTMLStyleElement *sheetElement = (DOMHTMLStyleElement *)[[self DOMDoc] getElementById:[NSString stringWithFormat:@"style%ld", size]];
    if(sheetElement == nil){
        return;
    }
    [self removeCSSRuleInStyleSheet:sheetElement withID:iuID];;
}

- (void)removeCSSRuleInStyleSheet:(DOMHTMLStyleElement *)styleSheet withID:(NSString *)iuID{
    
    NSString *newCSSText = [self removeCSSText:styleSheet.innerHTML withID:iuID];
    [styleSheet setInnerHTML:newCSSText];
    
    [[self webView] runJSAfterRefreshCSS];
    
}


- (NSString *)removeCSSText:(NSString *)innerCSSText withID:(NSString *)identifier
{
    NSMutableString *innerCSSHTML = [NSMutableString stringWithString:@"\n"];
    NSString *trimmedInnerCSSHTML = [innerCSSText  stringByTrim];
    NSArray *cssRuleList = [trimmedInnerCSSHTML componentsSeparatedByString:@"\n"];
    
    //    NSArray *cssRuleList = [trimmedInnerCSSHTML componentsSeparatedByCharactersInSet:
    //                          [NSCharacterSet characterSetWithCharactersInString:@"."]];
    
    for(NSString *rule in cssRuleList){
        if(rule.length == 0){
            continue;
        }
        NSString *ruleID = [self cssIDInCSSRule:rule];
        NSString *modifiedIdentifier = [identifier stringByTrim];
        if([ruleID isEqualToString:modifiedIdentifier] == NO){
            [innerCSSHTML appendString:[NSString stringWithFormat:@"\t%@\n", [rule stringByTrim]]];
        }
    }
    
    return innerCSSHTML;
}


#pragma mark -
#pragma mark GridView
- (GridView *)gridView{
    return ((LMCanvasView *)self.view).gridView;
}


/*
 ******************************************************************************************
 SET IU : View call IU
 ******************************************************************************************
 */
#pragma mark -
#pragma mark setIU

#pragma mark frameDict

- (void)updateIUFrameDictionary:(NSMutableDictionary *)iuFrameDict{
    JDTraceLog(@"report updated frame dict");

    for(NSString *identifier in iuFrameDict.allKeys){
        NSRect pixelFrame = [[iuFrameDict objectForKey:identifier] rectValue];
        IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
        [iu setPixelFrame:pixelFrame];
    }
}

- (void)updateIUPercentFrameDictionary:(NSMutableDictionary *)iuFrameDict{
 
    for(NSString *identifier in iuFrameDict.allKeys){
        NSRect percentFrame = [[iuFrameDict objectForKey:identifier] rectValue];
        IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
        [iu setPercentFrame:percentFrame];
        
        JDTraceLog(@"(%@ : %.1f,%.1f,%.1f,%.1f)",identifier,
                  percentFrame.origin.x, percentFrame.origin.y,
                  percentFrame.size.width, percentFrame.size.height);
    }

}


- (void)updateGridFrameDictionary:(NSMutableDictionary *)gridFrameDict{
    
    [[self gridView] updateLayerRect:gridFrameDict];
    
    
    NSArray *keys = [gridFrameDict allKeys];
    for(NSString *key in keys){
        if([frameDict.dict objectForKey:key]){
            [frameDict.dict removeObjectForKey:key];
        }
        [frameDict.dict setObject:[gridFrameDict objectForKey:key] forKey:key];
    }
    //draw guide line
    for (NSString *IUID in self.controller.selectedIdentifiers){
        [[self gridView] drawGuideLine:[frameDict lineToDrawSamePositionWithIU:IUID]];
    }
    
}

#pragma mark updatedText
- (void)updateHTMLText:(NSString *)insertText atIU:(NSString *)iuID{
    
    JDTraceLog(@"[IU:%@], %@", iuID, insertText);
}

#pragma mark moveIU
//drag & drop after select IU
- (void)moveIUToDiffPoint:(NSPoint)point totalDiffPoint:(NSPoint)totalPoint{
    if (point.x == 0 && point.y == 0) {
        return;
    }
    
    
    for(IUBox *obj in self.controller.selectedObjects){
        
        IUBox *moveObj= obj;
        
        if([self isParentMove:obj]){
            moveObj = obj.parent;
        }
        
        
        NSSize parentSize;
        if (self.controller.importIUInSelectionChain){
            NSString *modifiedHTMLID = [NSString stringWithFormat:@"ImportedBy_%@_%@",self.controller.importIUInSelectionChain.htmlID, moveObj.htmlID];
            parentSize = [[self webView] parentBlockElementSize:modifiedHTMLID];
        }
        else {
            parentSize = [[self webView] parentBlockElementSize:moveObj.htmlID];
        }

        /*
        if([frameDict isGuidePoint:totalPoint]){
            
            NSString *IUID = obj.htmlID;
            NSRect currentFrame = [[frameDict.dict objectForKey:IUID] rectValue];
            NSRect moveFrame = currentFrame;
            
            moveFrame.origin = NSMakePoint(currentFrame.origin.x+point.x, currentFrame.origin.y+point.y);
            NSPoint guidePoint = [frameDict guidePointOfCurrentFrame:moveFrame IU:IUID];
            guidePoint= NSMakePoint(guidePoint.x - currentFrame.origin.x, guidePoint.y - currentFrame.origin.y);
            
            
            [obj movePosition:NSMakePoint(guidePoint.x, guidePoint.y) withParentSize:parentSize];
            JDInfoLog(@"Point:(%.1f %.1f)", moveFrame.origin.x, moveFrame.origin.y);
            [obj updateCSSForEditViewPort];
        }
        else{
         */
        [moveObj movePosition:NSMakePoint(totalPoint.x, totalPoint.y) withParentSize:parentSize];
        [moveObj updateCSSForEditViewPort];
        
    }
}

- (BOOL)checkExtendSelectedIU:(NSSize)size{
    //drag pointlayer
    for(IUBox *obj in self.controller.selectedObjects){
        
        NSString *IUID = obj.htmlID;
        NSRect currentFrame = [[frameDict.dict objectForKey:IUID] rectValue];
        NSSize expectedSize = NSMakeSize(currentFrame.size.width+size.width, currentFrame.size.height+size.height);
        if(expectedSize.width < 0 || expectedSize.height < 0){
            return NO;
        }
    }
    return YES;
}

- (BOOL)isParentMove:(IUBox *)obj{
    if([obj respondsToSelector:@selector(shouldMoveParent)]){
        return [[obj performSelector:@selector(shouldMoveParent)] boolValue];
    }

    return  NO;
}

- (void)startDragSession:(id)sender{
    if([sender isKindOfClass:[GridView class]]){
        [((LMCanvasView *)[self view]) startDraggingFromGridView];
    }
    for(IUBox *obj in self.controller.selectedObjects){
        if([self isParentMove:obj]){
            [obj.parent startDragSession];
        }
        else{
            [obj startDragSession];
        }
    }
}


- (void)extendIUToDiffSize:(NSSize)size totalDiffSize:(NSSize)totalSize{
    //drag pointlayer
    [JDLogUtil timeLogStart:@"extendIU"];
    for(IUBox *obj in self.controller.selectedObjects){
        IUBox *moveObj= obj;
        
        if([self isParentMove:obj]){
            moveObj = obj.parent;
        }
        
        NSSize parentSize;
        if (self.controller.importIUInSelectionChain){
            NSString *modifiedHTMLID = [NSString stringWithFormat:@"ImportedBy_%@_%@",self.controller.importIUInSelectionChain.htmlID, moveObj.htmlID];
            parentSize = [[self webView] parentBlockElementSize:modifiedHTMLID];
        }
        else {
            parentSize = [[self webView] parentBlockElementSize:moveObj.htmlID];
        }
        
        /*
        if([frameDict isGuideSize:totalSize]){

            NSString *IUID = obj.htmlID;
            NSRect currentFrame = [[frameDict.dict objectForKey:IUID] rectValue];
            //NSSize expectedSize = NSMakeSize(currentFrame.size.width+size.width, currentFrame.size.height+size.height);
            NSRect moveFrame = currentFrame;
            
            moveFrame.size = NSMakeSize(currentFrame.size.width+size.width, currentFrame.size.height+size.height);
            NSSize guideSize = [frameDict guideSizeOfCurrentFrame:moveFrame IU:IUID];
            guideSize = NSMakeSize(guideSize.width- currentFrame.size.width, guideSize.height - currentFrame.size.height);
            
            [obj increaseSize:NSMakeSize(guideSize.width, guideSize.height) withParentSize:parentSize];
            [obj updateCSSForEditViewPort];
        }
        else{
         */
        [moveObj increaseSize:NSMakeSize(totalSize.width, totalSize.height) withParentSize:parentSize];
        [moveObj updateCSSForEditViewPort];
        
        
        /*
        JDTraceLog( @"[IU:%@]\n origin: (%.1f, %.1f) \n size: (%.1f, %.1f)",
                   IUID, guideFrame.origin.x, guideFrame.origin.y, guideFrame.size.width, guideFrame.size.height);
         */
        
    }
        [JDLogUtil timeLogEnd:@"extendIU"];
    
}


-(void)IURemoved:(NSString*)identifier withParentID:(NSString *)parentID{
    
    
    //remove HTML
    DOMHTMLElement *selectHTMLElement = [self getHTMLElementbyID:identifier];
    DOMHTMLElement *middleElement = selectHTMLElement;
    DOMHTMLElement *parentElement;
    while(1){
        parentElement = (DOMHTMLElement *)[middleElement parentElement];
        
        if([parentElement.idName isEqualToString:parentID]){
            break;
        }
        else if([parentElement isKindOfClass:[DOMHTMLBodyElement class]]){
            break;
        }
        else if(parentElement == nil){
            break;
        }
        
        middleElement = parentElement;
    }
    
//    NSAssert(parentElement != nil);
    
    [parentElement removeChild:middleElement];
    
    [self deselectedAllIUs];
    [self.controller rearrangeObjects];

    //remove layer
    [[self gridView] removeLayerWithIUIdentifier:identifier];
    [frameDict.dict removeObjectForKey:identifier];
    
    IUBox *iu = [_controller IUBoxByIdentifier:identifier];
    
    
    //removeCSS
    NSArray *cssIds = [iu cssIdentifierArray];
    for (NSString *identifier in cssIds){
        [self removeAllCSSWithIdentifier:identifier];
        [self removeAllCSSWithIdentifier:[identifier stringByAppendingString:@":hover"]];
    }
    
    
    //remove layer for children
    if ([iu isKindOfClass:[IUImport class]]){
        for(IUBox *child in iu.allChildren){
            NSString *modifiedHTMLID = [NSString stringWithFormat:@"ImportedBy_%@_%@",iu.htmlID, child.htmlID];
            [[self gridView] removeLayerWithIUIdentifier:modifiedHTMLID];
            [frameDict.dict removeObjectForKey:modifiedHTMLID];
            
            //FIXME: IMPORT css id??
            [self removeAllCSSWithIdentifier:modifiedHTMLID];

        }
        
    }
    else{
        for(IUBox *child in iu.allChildren){
            
            [[self gridView] removeLayerWithIUIdentifier:child.htmlID];
            [frameDict.dict removeObjectForKey:child.htmlID];
            
            NSArray *childIds= [child cssIdentifierArray];
            for (NSString *identifier in childIds){
                [self removeAllCSSWithIdentifier:identifier];
            }

        }
    }
    
    
}



#pragma mark HTMLSource

-(NSString *)currentHTML{
    NSString *htmlSource =  [(DOMHTMLElement *)[[[[self webView] mainFrame] DOMDocument] documentElement] outerHTML];
    return htmlSource;
}

#if DEBUG

- (void)applyHtmlString:(NSString *)html{
    [[[self webView] mainFrame] loadHTMLString:html baseURL:[NSURL fileURLWithPath:self.documentBasePath]];
}

- (void)reloadOriginalDocument{
    [self setSheet:_sheet];
}

- (IBAction)showCurrentSource:(id)sender {
    NSString *htmlSource =  [(DOMHTMLElement *)[[[[self webView] mainFrame] DOMDocument] documentElement] outerHTML];
    [_debugWC showWindow:self];
    [_debugWC.codeTextView setString:htmlSource];
    NSLog(@"\n%@\n",htmlSource);
}

#endif

- (void)copy:(id)sender{
    [self.controller copySelectedIUToPasteboard:self];
}

- (void)paste:(id)sender{
    [self.controller pasteToSelectedIU:self];
}

- (void)performRightClick:(NSString*)IUID withEvent:(NSEvent*)event{
    //make help menu
    NSMenu *menu = [[NSMenu alloc] init];
    NSMenuItem *helpItem = [[NSMenuItem alloc] init];
    helpItem.title = @"Help";
    NSMenu *helpMenu = [[NSMenu alloc] initWithTitle:@"Help"];
    [menu addItem:helpItem];
    [menu setSubmenu:helpMenu forItem:helpItem];
    
    

    //get className
    IUBox *selectedIU = [self.controller IUBoxByIdentifier:IUID];
    NSString *className = [selectedIU className];
    
    //pdf list
    NSString *pdfFilePath = [[NSBundle mainBundle] pathForResource:@"helpPdf" ofType:@"plist"];
    NSDictionary *pdfDict = [NSDictionary dictionaryWithContentsOfFile:pdfFilePath];
    
    //widget manual list
    NSString *widgetFilePath = [[NSBundle mainBundle] pathForResource:@"widgetForDefault" ofType:@"plist"];
    NSArray *availableWidgetProperties = [NSArray arrayWithContentsOfFile:widgetFilePath];
    NSDictionary *widget = [availableWidgetProperties objectWithKey:@"className" value:className];
    NSArray *helpArray = [widget objectForKey:@"manual"];
    for (NSString *pdfKey in helpArray) {
        NSMenuItem *item = [[NSMenuItem alloc] init];
        item.representedObject = pdfKey;
        item.title = [pdfDict objectForKey:pdfKey][@"title"];
        [helpMenu addItem:item];
        item.target = self;
        [item setAction:@selector(performHelp:)];
    }
    
    //get
    [NSMenu popUpContextMenu:menu withEvent:event forView:self.view];
}

- (void)performHelp:(NSMenuItem *)sender{
    helpWC = [LMHelpWC sharedHelpWC];
    [helpWC showHelpDocumentWithKey:sender.representedObject];
}
@end
