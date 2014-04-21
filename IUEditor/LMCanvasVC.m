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
#import "InnerSizeBox.h"

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
    [[self sizeView] addFrame:defaultFrameWidth];
    [[self sizeView] addFrame:400];
    [[self sizeView] addFrame:700];
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

#pragma mark -
#pragma mark call by sizeView


- (SizeView *)sizeView{
    return ((LMCanvasView *)self.view).sizeView;
    
}

- (void)refreshGridFrameDictionary{
    [[self webView] updateFrameDict];
}

#pragma mark -
#pragma mark call by webView

- (WebCanvasView *)webView{
    return ((LMCanvasView *)self.view).webView;
}

- (DOMDocument *)DOMDoc{
    return [[[self webView] mainFrame] DOMDocument];
}


- (void)setDocument:(IUDocument *)document{
    NSAssert(self.documentBasePath != nil, @"resourcePath is nil");
    JDSectionInfoLog( IULogSource, @"resourcePath  : %@", self.documentBasePath);
    [_document setDelegate:nil];
    _document = document;
    [_document setDelegate:self];
    
    [[[self webView] mainFrame] loadHTMLString:document.editorSource baseURL:[NSURL fileURLWithPath:self.documentBasePath]];
}

- (void)makeNewIU:(IUBox *)newIU atPoint:(NSPoint)point atIU:(NSString *)parentIUID{
    
    IUBox *parentIU = [self.controller IUBoxByIdentifier:parentIUID];
 //   parentIU.
    NSPoint position = [self distanceFromIU:parentIU.htmlID toPointFromWebView:point];
    
    //postion을 먼저 정한 후에 add 함
    [newIU setPosition:position];
    [parentIU addIU:newIU error:nil];
    [self.controller rearrangeObjects];
    [self.controller setSelectedObjectsByIdentifiers:@[newIU.htmlID]];
    
    JDTraceLog( @"[IU:%@] : point(%.1f, %.1f) atIU:%@", newIU.htmlID, point.x, point.y, parentIUID);
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
    

    for(NSString *IUID in self.controller.selectedIdentifiers){
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
    NSArray *addArray = [NSArray arrayWithObject:IU];
    [self.controller setSelectedObjectsByIdentifiers:addArray];
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
//text
- (void)selectTextRange:(NSRange)range identifier:(NSString *)identifier{
    self.controller.selectedTextRange = range;
}

- (void)insertString:(NSString *)string identifier:(NSString *)identifier withRange:(NSRange)range{
    IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
    assert(iu != nil);
    [iu insertText:string withRange:range];
}

- (void)deleteStringRange:(NSRange)range identifier:(NSString *)identifier{
    IUBox *iu = [self.controller IUBoxByIdentifier:identifier];
    [iu deleteTextInRange:range];
}

#pragma mark -
#pragma mark IUDelegate

- (NSPoint)distanceFromIU:(NSString *)parentName to:(NSString *)iuName{
    NSRect iuFrame = [[frameDict.dict objectForKey:iuName] rectValue];
    NSRect parentFrame = [[frameDict.dict objectForKey:parentName] rectValue];
    
    NSPoint distance = NSMakePoint(iuFrame.origin.x-parentFrame.origin.x,
                                   iuFrame.origin.y - parentFrame.origin.y);
    return distance;
}


- (NSPoint)distanceFromIU:(NSString*)parentName toPointFromWebView:(NSPoint)point{
    
    NSRect parentFrame = [[frameDict.dict objectForKey:parentName] rectValue];
    
    NSPoint distance = NSMakePoint(point.x-parentFrame.origin.x,
                                   point.y - parentFrame.origin.y);
    return distance;
}

#pragma mark -
#pragma mark link attributes
-(void)IU:(NSString *)identifier setLink:(NSString *)link{
    
    if(link==nil || link.length == 0){
        //remove link
        [self IURemoveLink:identifier];
        return;
    }
    
    
    NSString *linkID =[NSString stringWithFormat:@"A_LINK_%@", identifier];
    DOMHTMLElement *linkElement = [self getHTMLElementbyID:linkID];
    //change link
    if(linkElement){
        [linkElement setAttribute:@"link" value:link];
    }
    //make new link
    else{
        DOMHTMLElement *selectHTMLElement = [self getHTMLElementbyID:identifier];
        NSString *linkHTML = [NSString stringWithFormat:@"<a href=\"%@\" id=\"%@\">%@</a>",
                              link, linkID, selectHTMLElement.outerHTML];
    
        [selectHTMLElement setOuterHTML:linkHTML];
    }
    
}
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

-(void)IU:(NSString*)identifier textHTML:(NSString *)html withParentID:(NSString *)parentID nearestID:(NSString *)nID index:(NSUInteger)index{
    
    [self IU:identifier HTML:html withParentID:parentID];
    [[self webView] selectTextRange:[self getHTMLElementbyID:nID] index:index];

}


-(void)IU:(NSString*)identifier HTML:(NSString *)html withParentID:(NSString *)parentID{

    DOMHTMLElement *currentElement = [self getHTMLElementbyID:identifier];
    if(currentElement){
        //change html text
        [currentElement setOuterHTML:html];
    }
    else{
        //insert html
        DOMHTMLElement *selectHTMLElement = [self getHTMLElementbyID:parentID];
        DOMHTMLElement *newElement = (DOMHTMLElement *)[self.DOMDoc createElement:[self tagWithHTML:html]];
        [selectHTMLElement appendChild:newElement];
        
        [newElement setOuterHTML:html];
    }
    [self.webView setNeedsDisplay:YES];
}



#pragma mark -
#pragma mark CSS


-(void)IU:(NSString*)identifier CSSChanged:(NSString*)css forWidth:(NSInteger)width{
    JDDebugLog(@"[%@:width:%ld] / %@ ", identifier, width, css);
    
    NSString *cssText = [NSString stringWithFormat:@"#%@{%@}", identifier, css];
    if(width == IUCSSDefaultCollection){
        //default setting
        [self setIUStyle:cssText withID:identifier];
    }
    else{
        [self setIUStyle:cssText withID:identifier size:width];
        
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
    
    [[self webView] updateFrameDict];
    
}

- (NSString *)innerCSSText:(NSString *)innerCSSText byAddingCSSText:(NSString *)cssText withID:(NSString *)iuID
{
    NSMutableString *innerCSSHTML = [NSMutableString stringWithString:@"\n"];
    NSString *trimmedInnerCSSHTML = [innerCSSText  stringByTrim];
    NSArray *cssRuleList = [trimmedInnerCSSHTML componentsSeparatedByCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@"#"]];

    for(NSString *rule in cssRuleList){
        if([rule containsString:iuID] == NO
           && [rule containsString:@"{"]
           && [rule containsString:@"}"]){
            [innerCSSHTML appendString:[NSString stringWithFormat:@"\t#%@\n", [rule stringByTrim]]];
        }
    }
    
    [innerCSSHTML appendString:cssText];
    [innerCSSHTML appendString:@"\n"];
    
    return innerCSSHTML;
}


#pragma mark -
#pragma mark GridView
- (GridView *)gridView{
    return ((LMCanvasView *)self.view).gridView;
}


#pragma mark -
#pragma mark border, ghost view

- (void)setGhostImage:(NSImage *)ghostImage{
    [[self gridView] setGhostImage:ghostImage];
}
- (void)setGhostPosition:(NSPoint)position{
    [[self gridView] setGhostPosition:position];
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
    
    
    //TODO: updated frame dict to IU
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
    for(IUBox *obj in self.controller.selectedObjects){
        
        if([frameDict isGuidePoint:totalPoint]){
            
            NSString *IUID = obj.htmlID;
            NSRect currentFrame = [[frameDict.dict objectForKey:IUID] rectValue];
            NSRect moveFrame = currentFrame;
            
            moveFrame.origin = NSMakePoint(currentFrame.origin.x+point.x, currentFrame.origin.y+point.y);
            NSPoint guidePoint = [frameDict guidePointOfCurrentFrame:moveFrame IU:IUID];
            guidePoint= NSMakePoint(guidePoint.x - currentFrame.origin.x, guidePoint.y - currentFrame.origin.y);
            
            
            [obj moveX:guidePoint.x Y:guidePoint.y];
            JDInfoLog(@"Point:(%.1f %.1f)", moveFrame.origin.x, moveFrame.origin.y);
        }
        else{
            [obj moveX:point.x Y:point.y];
        }
        
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

- (void)extendIUToDiffSize:(NSSize)size totalDiffSize:(NSSize)totalSize{
    //drag pointlayer
    for(IUBox *obj in self.controller.selectedObjects){
        if([frameDict isGuideSize:totalSize]){
            NSString *IUID = obj.htmlID;
            NSRect currentFrame = [[frameDict.dict objectForKey:IUID] rectValue];
            NSSize expectedSize = NSMakeSize(currentFrame.size.width+size.width, currentFrame.size.height+size.height);
            NSRect moveFrame = currentFrame;
            
            moveFrame.size = NSMakeSize(currentFrame.size.width+size.width, currentFrame.size.height+size.height);
            NSSize guideSize = [frameDict guideSizeOfCurrentFrame:moveFrame IU:IUID];
            guideSize = NSMakeSize(guideSize.width- currentFrame.size.width, guideSize.height - currentFrame.size.height);
            
            [obj increaseWidth:guideSize.width height:guideSize.height];
        }
        else{
            [obj increaseWidth:size.width height:size.height];
        }
        
        /*
        JDTraceLog( @"[IU:%@]\n origin: (%.1f, %.1f) \n size: (%.1f, %.1f)",
                   IUID, guideFrame.origin.x, guideFrame.origin.y, guideFrame.size.width, guideFrame.size.height);
         */
        
    }
    
}


- (void)IURemoved:(NSString*)identifier{
    //remove HTML
    DOMHTMLElement *selectHTMLElement = [self getHTMLElementbyID:identifier];
    DOMElement *parentElement = [selectHTMLElement parentElement];
    [parentElement removeChild:selectHTMLElement];
    
    [self deselectedAllIUs];
    [frameDict.dict removeObjectForKey:identifier];
    [self.controller rearrangeObjects];
    
    
    //TODO: remove CSS
    // - 꼭 필요한가??
    
    
}



#pragma mark HTMLSource

-(NSString *)currentHTML{
    NSString *htmlSource =  [(DOMHTMLElement *)[[[[self webView] mainFrame] DOMDocument] documentElement] outerHTML];
    return htmlSource;
}
//TODO: remove it
- (void)showCurrentSource{
    NSString *htmlSource =  [(DOMHTMLElement *)[[[[self webView] mainFrame] DOMDocument] documentElement] outerHTML];
    JDInfoLog(@"\n%@\n",htmlSource);

}



@end
