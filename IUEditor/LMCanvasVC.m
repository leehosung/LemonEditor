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
#import "IUResponsiveSection.h"
#import "IUImport.h"

@interface LMCanvasVC ()

@end

@implementation LMCanvasVC{
    IUFrameDictionary *frameDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        frameDict = [[IUFrameDictionary alloc] init];;
    }
    return self;
}

-(void)awakeFromNib{
    
    [self addObserver:self forKeyPath:@"view.sizeView.sizeArray" options:NSKeyValueObservingOptionInitial context:@"mqCount"];
    [self addObserver:self forKeyPaths:@[@"document.ghostImageName",
                                         @"document.ghostX",
                                         @"document.ghostY",
                                         @"document.ghostOpacity"]
              options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:@"ghostImage"];
}


-(void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selectedObjects" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:nil];
}


-(LMCanvasView*)view{
    return (LMCanvasView*)[super view];
}

-(void)changeIUPageHeight:(CGFloat)pageHeight{
    [self.view setHeightOfMainView:pageHeight];
}

- (void)addFrame:(NSInteger)frameSize{
    [[self sizeView] addFrame:frameSize];
}


#pragma mark -
#pragma mark call by sizeView


- (SizeView *)sizeView{
    return ((LMCanvasView *)self.view).sizeView;
    
}

- (void)refreshGridFrameDictionary{
    [[self webView] updateFrameDict];
}

- (void)mqCountContextDidChange:(NSDictionary *)change{
    _document.mqSizeArray = [self sizeView].sortedArray;
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
    if ([parentIU shouldAddIUByUserInput] == NO) {
        return NO;
    }
    NSPoint position = [self distanceFromIU:parentIUID toPointFromWebView:point];
        
    //postion을 먼저 정한 후에 add 함
    [newIU setPosition:position];
    [parentIU addIU:newIU error:nil];
    [parentIU.identifierManager registerIU:parentIU];
    [self.controller rearrangeObjects];
    [self.controller setSelectedObjectsByIdentifiers:@[newIU.htmlID]];
    
    JDTraceLog( @"[IU:%@] : point(%.1f, %.1f) atIU:%@", newIU.htmlID, point.x, point.y, parentIUID);
    return YES;
}

- (void)removeSelectedIUs{
    for(IUBox *obj in self.controller.selectedObjects){
        [obj.parent removeIU:obj];
    }
}

-(void)insertImage:(NSString *)name atIU:(NSString *)identifier{
    IUBox *currentIU = [self.controller IUBoxByIdentifier:identifier];
    [currentIU insertImage:name];
}

#pragma mark -
#pragma mark call by Document

- (void)setDocument:(IUDocument *)document{
    NSAssert(self.documentBasePath != nil, @"resourcePath is nil");
    JDSectionInfoLog( IULogSource, @"resourcePath  : %@", self.documentBasePath);
    [[self gridView] clearAllLayer];
    [_document setDelegate:nil];
    _document = document;
    _document.mqSizeArray = [self sizeView].sortedArray;
    [_document setDelegate:self];
    
    [[[self webView] mainFrame] loadHTMLString:document.editorSource baseURL:[NSURL fileURLWithPath:self.documentBasePath]];
}

- (void)ghostImageContextDidChange:(NSDictionary *)change{
    NSString *ghostImageName = _document.ghostImageName;
    IUResourceNode *resourceNode = [_resourceManager imageResourceNodeOfName:ghostImageName];
    NSImage *ghostImage = [[NSImage alloc] initWithContentsOfFile:resourceNode.absolutePath];
    
    [[self gridView] setGhostImage:ghostImage];
    
    NSPoint ghostPosition = NSMakePoint(_document.ghostX, _document.ghostY);
    [[self gridView] setGhostPosition:ghostPosition];
    
    [[self gridView] setGhostOpacity:_document.ghostOpacity];
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
    if([self countOfSelectedIUs] == 1){
        IUBox *currentIU = self.controller.selectedObjects[0];
        if(currentIU.shouldEditText){
            return YES;
        }
    }
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
    
    [[self gridView] removeAllRedPointLayer];
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
            [[self gridView] addRedPointLayer:IUID withFrame:frame];
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
    NSArray *addArray = [NSArray arrayWithObject:identifier];
    NSArray *currentSelectinos = [[self.controller selectedObjects] valueForKeyPath:@"htmlID"];
    if ([addArray isEqualToArray:currentSelectinos]) {
        return;
    }
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

- (void)selectTextRange:(NSRange)range identifier:(NSString *)identifier startContainer:(NSString *)startContainer endContainer:(NSString *)endContainer htmlNode:(DOMHTMLElement *)node{

    IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
    assert(iu != nil);
    
    [iu selectTextRange:range startContainer:startContainer endContainer:endContainer htmlNode:node];

}
/*
//text
- (void)selectTextRange:(NSRange)range identifier:(NSString *)identifier{
    self.controller.selectedTextRange = range;
}

- (void)insertString:(NSString *)string identifier:(NSString *)identifier withRange:(NSRange)range{
    [JDLogUtil log:IULogText string:[NSString stringWithFormat:@"insert - %@ , (%lu, %lu)", string, range.location, range.length]];
    IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
    assert(iu != nil);
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
        
        IUBox *iu = [_controller IUBoxByIdentifier:identifier];
        if([iu isKindOfClass:[IUCarousel class]]){
            [[self webView] insertNewCarousel:identifier];
        }
        /*        //insert html
         DOMNodeList *list = [self getHTMLElementsByClassName:parentID];
         unsigned int listCount = [list length];
         for(unsigned int i=0; i<listCount; i++){
         DOMHTMLElement *selectHTMLElement = (DOMHTMLElement *)[list item:i];
         
         DOMHTMLElement *newElement = (DOMHTMLElement *)[self.DOMDoc createElement:[self tagWithHTML:html]];
         [selectHTMLElement appendChild:newElement];
         
         [newElement setOuterHTML:html];
         
         IUBox *iu = [_controller IUBoxByIdentifier:identifier];
         if([iu isKindOfClass:[IUCarousel class]]){
         [[self webView] insertNewCarousel:identifier];
         }
*/
    }
    
//    JDDebugLog(@"%@:%@", identifier, html);

    [[self webView] runJSAfterRefreshCSS];
    [self.webView setNeedsDisplay:YES];
}



#pragma mark -
#pragma mark CSS

-(void)IUClassIdentifier:(NSString *)identifier CSSRemovedforWidth:(NSInteger)width{
    if(width == IUCSSMaxViewPortWidth){
        //default setting
        [self removeCSSTextWithID:identifier];
    }
    else{
        [self removeCSSTextWithID:identifier size:width];
        
    }
    [self.webView setNeedsDisplay:YES];
}


-(void)IUClassIdentifier:(NSString*)identifier CSSUpdated:(NSString*)css forWidth:(NSInteger)width{
    [JDLogUtil log:IULogSource key:@"css" string:css];
    
    if(css.length == 0){
        //nothing to do
        [self IUClassIdentifier:identifier CSSRemovedforWidth:width];
    }else{
        
        NSString *cssText = [NSString stringWithFormat:@".%@{%@}", identifier, css];
        if(width == IUCSSMaxViewPortWidth){
            //default setting
            [self setIUStyle:cssText withID:identifier];
        }
        else{
            [self setIUStyle:cssText withID:identifier size:width];
            
        }
        [self.webView setNeedsDisplay:YES];
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

- (NSString *)innerCSSText:(NSString *)innerCSSText byAddingCSSText:(NSString *)cssText withID:(NSString *)iuID
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
        NSString *modifiedIUID = [@"." stringByAppendingString:iuID];
        if([ruleID isEqualToString:modifiedIUID] == NO){
            [innerCSSHTML appendString:[NSString stringWithFormat:@"\t%@\n", [rule stringByTrim]]];
        }
    }
    
    [innerCSSHTML appendString:cssText];
    [innerCSSHTML appendString:@"\n"];
    
    return innerCSSHTML;
}

- (void)removeCSSTextWithID:(NSString *)iuID{
    DOMHTMLStyleElement *sheetElement = (DOMHTMLStyleElement *)[[self DOMDoc] getElementById:@"default"];
    [self removeCSSRuleInStyleSheet:sheetElement withID:iuID];
    
}
- (void)removeCSSTextWithID:(NSString *)iuID size:(NSInteger)size{
    DOMHTMLStyleElement *sheetElement = (DOMHTMLStyleElement *)[[self DOMDoc] getElementById:[NSString stringWithFormat:@"style%ld", size]];
    if(sheetElement == nil){
        sheetElement = [self makeNewStyleSheet:size];
    }
    [self removeCSSRuleInStyleSheet:sheetElement withID:iuID];;
}

- (void)removeCSSRuleInStyleSheet:(DOMHTMLStyleElement *)styleSheet withID:(NSString *)iuID{
    
    NSString *newCSSText = [self removeCSSText:styleSheet.innerHTML withID:iuID];
    [styleSheet setInnerHTML:newCSSText];
    
    [[self webView] runJSAfterRefreshCSS];
    
}


- (NSString *)removeCSSText:(NSString *)innerCSSText withID:(NSString *)iuID
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
        NSString *modifiedIUID = [@"." stringByAppendingString:iuID];
        if([ruleID isEqualToString:modifiedIUID] == NO){
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
        NSSize parentSize;
        if (self.controller.importIUInSelectionChain){
            NSString *modifiedHTMLID = [NSString stringWithFormat:@"%@__%@",self.controller.importIUInSelectionChain.htmlID, obj.htmlID];
            parentSize = [[self webView] parentBlockElementSize:modifiedHTMLID];
        }
        else {
            parentSize = [[self webView] parentBlockElementSize:obj.htmlID];
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
        [obj movePosition:NSMakePoint(totalPoint.x, totalPoint.y) withParentSize:parentSize];
        [obj updateCSSForEditViewPort];
        
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

- (void)startDragSession{
    for(IUBox *obj in self.controller.selectedObjects){
        [obj startDragSession];
    }
}


- (void)extendIUToDiffSize:(NSSize)size totalDiffSize:(NSSize)totalSize{
    //drag pointlayer
    [JDLogUtil timeLogStart:@"extendIU"];
    for(IUBox *obj in self.controller.selectedObjects){
        
        NSSize parentSize;
        if (self.controller.importIUInSelectionChain){
            NSString *modifiedHTMLID = [NSString stringWithFormat:@"%@__%@",self.controller.importIUInSelectionChain.htmlID, obj.htmlID];
            parentSize = [[self webView] parentBlockElementSize:modifiedHTMLID];
        }
        else {
            parentSize = [[self webView] parentBlockElementSize:obj.htmlID];
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
        [obj increaseSize:NSMakeSize(totalSize.width, totalSize.height) withParentSize:parentSize];
        [obj updateCSSForEditViewPort];
        
        
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
    
//    assert(parentElement != nil);
    
    [parentElement removeChild:middleElement];
    
    [self deselectedAllIUs];
    [frameDict.dict removeObjectForKey:identifier];
    [self.controller rearrangeObjects];
    
    [[self gridView] removeLayerWithIUIdentifier:identifier];
}



#pragma mark HTMLSource

-(NSString *)currentHTML{
    NSString *htmlSource =  [(DOMHTMLElement *)[[[[self webView] mainFrame] DOMDocument] documentElement] outerHTML];
    return htmlSource;
}

- (IBAction)showCurrentSource:(id)sender {
    NSString *htmlSource =  [(DOMHTMLElement *)[[[[self webView] mainFrame] DOMDocument] documentElement] outerHTML];
    NSLog(@"\n%@\n",htmlSource);
}

- (void)copy:(id)sender{
    [self.controller copySelectedIUToPasteboard:self];
}

- (void)paste:(id)sender{
    [self.controller pasteToSelectedIU:self];
}

@end
