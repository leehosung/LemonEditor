//
//  CanvasWebView.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 21..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "WebCanvasView.h"
#import "LMCanvasVC.h"
#import "JDLogUtil.h"
#import "LMCanvasView.h"
#import "IUBox.h"

@implementation WebCanvasView

- (id)init{
    
    self = [super init];
    if(self){
        //connect delegate
        [self setUIDelegate:self];
        [self setResourceLoadDelegate:self];
        [self setEditingDelegate:self];
        [self setFrameLoadDelegate:self];
        [self setPolicyDelegate:self];
        [self setEditable:NO];
        
        [[[self mainFrame] frameView] setAllowsScrolling:NO];
        
        [self registerForDraggedTypes:@[(id)kUTTypeIUType, (id)kUTTypeIUImageResource]];
    }
    
    return self;
    
}

- (BOOL)isFlipped{
    return YES;
}

#pragma mark -
#pragma mark Event

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent{
/*
 * NOTE :
 * deletekey는 performKeyequvalent로 들어오지않음
 * window sendevent를 받아서 lmcanvasview에서 처리
 */

    NSResponder *currentResponder = [[self window] firstResponder];
    NSView *mainView = ((LMCanvasVC *)self.delegate).view.mainView;
    
    if([currentResponder isKindOfClass:[NSView class]]
       && [mainView hasSubview:(NSView *)currentResponder]){
    
        if(theEvent.type == NSKeyDown){
            unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
            
            if([theEvent modifierFlags] & NSCommandKeyMask){
                //select all
                if(key == 'A' || key == 'a'){
                    [self selectWholeRangeOfCurrentCursor];
                    return YES;
                }
                
            }
            else{
                unsigned short keyCode = theEvent.keyCode;

                if([self isEditable]){
                    //ESC key
                    if(keyCode == 53){
                        [self setEditable:NO];
                    }
                }
                else{
                    //arrow key
                    if(keyCode < 127 && keyCode > 122){
                        [self moveIUByKeyEvent:keyCode];
                    }
                }
            }
        }
    }
    return [super performKeyEquivalent:theEvent];
}

- (void)moveIUByKeyEvent:(unsigned short)keyCode{
    NSPoint diffPoint;
    switch (keyCode) {
        case 126: //up
            diffPoint = NSMakePoint(0, -1.0);
            break;
        case 123: // left
            diffPoint = NSMakePoint(-1.0, 0);
            break;
        case 124: // right
            diffPoint = NSMakePoint(1.0, 0);
            break;
        case 125: // down;
            diffPoint = NSMakePoint(0, 1.0);
            break;
        default:
            diffPoint = NSZeroPoint;
            break;
    }
    
    [((LMCanvasVC *)self.delegate) moveIUToDiffPoint:diffPoint totalDiffPoint:diffPoint];
}


#pragma mark -
#pragma mark mouse operation

- (NSUInteger)webView:(WebView *)webView dragSourceActionMaskForPoint:(NSPoint)point{
    return WebDragSourceActionNone;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
    return NSDragOperationEvery;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender{
    return NSDragOperationEvery;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender{
    
    NSPasteboard *pBoard = sender.draggingPasteboard;
    NSPoint dragPoint = sender.draggingLocation;
    NSPoint convertedPoint = [self convertPoint:dragPoint fromView:nil];
    
    //type1) newIU
    NSData *iuData = [pBoard dataForType:(id)kUTTypeIUType];
    if(iuData){
        IUBox *newIU = [NSKeyedUnarchiver unarchiveObjectWithData:iuData];
        if(newIU){
            NSString *parentIUID = [self IUAtPoint:convertedPoint];
            if(parentIUID){
                [((LMCanvasVC *)(self.delegate)) makeNewIU:newIU atPoint:convertedPoint atIU:parentIUID];
                JDTraceLog( @"[IU:%@], dragPoint(%.1f, %.1f)", newIU.htmlID, dragPoint.x, dragPoint.y);
                return YES;
            }
        }
        return NO;
    }
    //type2) resourceImage
    NSString *imageName = [pBoard stringForType:(id)kUTTypeIUImageResource];
    if(imageName){
        NSString *currentIUID = [self IUAtPoint:convertedPoint];
        if(currentIUID){
            [((LMCanvasVC *)(self.delegate))insertImage:imageName atIU:currentIUID];
            return YES;
        }
    }
    
    return NO;
}


- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags{
    //whem mouse move, save current element!
    currentNode = [elementInformation objectForKey:WebElementDOMNodeKey];
    
    currentNode = [self IUNodeAtCurrentNode:currentNode];
    
    if(currentNode.idName){
        JDTraceLog( @"%@", currentNode.idName);
    }
}



#pragma mark -
#pragma mark Javascript with WebView
- (void)webView:(WebView *)webView didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame{
    [windowObject setValue:self forKey:@"console"];
}


+ (NSString *)webScriptNameForSelector:(SEL)selector{
    if (selector == @selector(doOutputToLog:)){
        return @"log";
    }
    else if(selector == @selector(reportFrameDict:)){
        return @"reportFrameDict";
    }
    else{
        return nil;
    }
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
    if (selector == @selector(reportFrameDict:)
        || selector == @selector(doOutputToLog:)
        ){
        return NO;
    }
    return YES;
}


/* Here is our Objective-C implementation for the JavaScript console.log() method.
 */
- (void)doOutputToLog:(NSString*)theMessage {
    JDSectionInfoLog(IULogJS, @"LOG: %@", theMessage);
}


#pragma mark -
#pragma mark scriptObject



- (NSArray*) convertWebScriptObjectToNSArray:(WebScriptObject*)webScriptObject
{
    // Assumption: webScriptObject has already been tested using isArray:
    
    NSUInteger count = [[webScriptObject valueForKey:@"length"] integerValue];
    NSMutableArray *a = [NSMutableArray array];
    for (unsigned i = 0; i < count; i++) {
        id item = [webScriptObject webScriptValueAtIndex:i];
        if ([item isKindOfClass:[WebScriptObject class]]) {
            [a addObject:[self convertWebScriptObjectToNSDictionary:item]];
        } else {
            [a addObject:item];
        }
    }
    
    return a;
}

- (NSMutableDictionary*) convertWebScriptObjectToNSDictionary:(WebScriptObject*)webScriptObject
{
    WebScriptObject* keysObject = [[self windowScriptObject] callWebScriptMethod:@"getDictionaryKeys" withArguments:[NSArray arrayWithObject:webScriptObject]];
    NSArray* keys = [self convertWebScriptObjectToNSArray:keysObject];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    
    NSEnumerator* enumerator = [keys objectEnumerator];
    id key;
    while (key = [enumerator nextObject]) {
        id value = [webScriptObject valueForKey:key];
        
        if([value isKindOfClass:[WebScriptObject class]]){
            [dict setObject:[self convertWebScriptObjectToNSDictionary:value] forKey:key];
        }
        else{
            [dict setObject:value forKey:key];
        }
    }
    
    return dict;
}



#pragma mark -
#pragma mark IUFrame


- (void)reportFrameDict:(WebScriptObject *)scriptObj{
    NSMutableDictionary *scriptDict = [self convertWebScriptObjectToNSDictionary:scriptObj];
    NSMutableDictionary *iuFrameDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *gridFrameDict = [NSMutableDictionary dictionary];
    
    NSArray *keys = [scriptDict allKeys];
    for(NSString *key in keys){
        NSDictionary *innerDict = [scriptDict objectForKey:key];
        
        CGFloat left = [[innerDict objectForKey:@"left"] floatValue];
        CGFloat top = [[innerDict objectForKey:@"top"] floatValue];
        CGFloat x = [[innerDict objectForKey:@"x"] floatValue];
        CGFloat y = [[innerDict objectForKey:@"y"] floatValue];
        CGFloat w = [[innerDict objectForKey:@"width"] floatValue];
        CGFloat h = [[innerDict objectForKey:@"height"] floatValue];
        
        NSRect iuFrame = NSMakeRect(left, top, w, h);
        [iuFrameDict setObject:[NSValue valueWithRect:iuFrame] forKey:key];
        NSRect gridFrame = NSMakeRect(x, y, w, h);
        [gridFrameDict setObject:[NSValue valueWithRect:gridFrame] forKey:key];
    }
    
    
    [((LMCanvasVC *)(self.delegate)) updateIUFrameDictionary:iuFrameDict];
    [((LMCanvasVC *)(self.delegate)) updateGridFrameDictionary:gridFrameDict];
    JDTraceLog( @"reportSharedFrameDict");
}

- (void)updateFrameDict{
    //reportFrameDict(after call setIUCSSStyle)
    [self stringByEvaluatingJavaScriptFromString:@"getIUUpdatedFrameThread()"];
}

- (void)resizePageContent{
    [self stringByEvaluatingJavaScriptFromString:@"resizePageContentHeight()"];
}

#pragma mark -
#pragma mark text



- (BOOL)isOneIUSTextelection:(DOMRange *)range{
    DOMNode *startContainer = range.startContainer;
    if([startContainer isKindOfClass:[DOMText class]]){
        startContainer = [self IUNodeAtCurrentNode:startContainer];
    }
    DOMNode *ancestorContainer = range.commonAncestorContainer;
    if([ancestorContainer isKindOfClass:[DOMText class]]){
        ancestorContainer = [self IUNodeAtCurrentNode:ancestorContainer];
    }
    
    if ([startContainer isEqualTo:ancestorContainer]){
        return YES;
    }
    else{
        return NO;
    }
    
}

- (NSRange)selectedRange:(DOMRange *)proposedRange InIU:(DOMHTMLElement *)proposedNode{
    DOMRange *totalRange = [proposedRange cloneRange];
    [totalRange selectNodeContents:proposedNode];
    [totalRange setEnd:proposedRange.startContainer offset:proposedRange.startOffset];
    
   return NSMakeRange(totalRange.text.length , proposedRange.text.length);
}

- (BOOL)webView:(WebView *)webView shouldInsertText:(NSString *)text replacingDOMRange:(DOMRange *)range givenAction:(WebViewInsertAction)action{
    
    DOMHTMLElement *IUNode = [self IUNodeAtCurrentNode:range.startContainer];
    if(IUNode == nil
        || [IUNode.idName isNotEqualTo:[((LMCanvasVC *)self.delegate) selectedIUIdentifier]]){
        return NO;
    }
    
    //FIXME: attribute isWirtable
    BOOL isWritable = YES;
    NSString *writableValue = [IUNode getAttribute:@"isWritable"];
    if(writableValue != nil && writableValue.length != 0){
        isWritable = [writableValue boolValue];
    }
    
    //insert Text
    if (isWritable){
        NSRange iuRange = [self selectedRange:range InIU:IUNode];
        [((LMCanvasVC *)self.delegate) insertString:text identifier:IUNode.idName withRange:iuRange];

        JDInfoLog(@"insertText [IU:%@] : range(%ld, %ld) : %@ ", IUNode.idName, iuRange.location, iuRange.length, text);
    }
    return NO;
}

- (BOOL)webView:(WebView *)webView shouldDeleteDOMRange:(DOMRange *)range{
    
    DOMHTMLElement *IUNode = [self IUNodeAtCurrentNode:range.startContainer];
    if(IUNode == nil
        || [IUNode.idName isNotEqualTo:[((LMCanvasVC *)self.delegate) selectedIUIdentifier]]){

        return NO;
    }
    if([self isOneIUSTextelection:range] == NO){
        return NO;
    }

    
    //FIXME: attribute isWirtable
    BOOL isWritable = YES;
    NSString *writableValue = [IUNode getAttribute:@"isWritable"];
    if(writableValue != nil && writableValue.length != 0){
        isWritable = [writableValue boolValue];
    }
    
    //insert Text
    if (isWritable){
        NSRange iuRange = [self selectedRange:range InIU:IUNode];
        [((LMCanvasVC *)self.delegate) deleteStringRange:iuRange identifier:IUNode.idName];
        JDInfoLog(@"DeleteText[IU:%@] : range(%ld, %ld) ", IUNode.idName, iuRange.location, iuRange.length);
    }
    return NO;

}


- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange toDOMRange:(DOMRange *)proposedRange affinity:(NSSelectionAffinity)selectionAffinity stillSelecting:(BOOL)flag{
    if([self isEditable] == NO){
        return NO;
    }

    if([self isOneIUSTextelection:proposedRange]){
        NSArray * selectednames = ((LMCanvasVC *)(self.delegate)).controller.selectedIdentifiers;
        DOMHTMLElement *proposedNode = [self IUNodeAtCurrentNode:proposedRange.startContainer];
        NSString *proposeIUID = proposedNode.idName;
        
        if(selectednames.count == 1 && [selectednames[0] isEqualToString:proposeIUID]){
         
            NSRange selectRangeInIU = [self selectedRange:proposedRange InIU:proposedNode];
            [((LMCanvasVC *)self.delegate) selectTextRange:selectRangeInIU identifier:proposeIUID];
            JDInfoLog(@"SelectedRange : (%ld, %ld)", selectRangeInIU.location, selectRangeInIU.length);
            
            return YES;
        }
    }
    
    return NO;
}

- (void)changeDOMRange:(NSPoint)point{
    DOMRange *range = [self editableDOMRangeForPoint:point];
    [self setSelectedDOMRange:range affinity:NSSelectionAffinityDownstream];
}

- (void)selectWholeRangeOfCurrentCursor{

    DOMRange *range = [self selectedDOMRange];
    
    if([range.startContainer isKindOfClass:[DOMText class]]){
        DOMText *currentContainer = (DOMText *)range.startContainer;
        int size = (int)currentContainer.wholeText.length;
        
        [range setStart:range.startContainer offset:0];
        [range setEnd:range.startContainer offset:size];
        
        [self setSelectedDOMRange:range affinity:NSSelectionAffinityDownstream];
    }

}

- (void)selectTextRange:(DOMHTMLElement *)element start:(int)start end:(int)end{
    DOMRange *range = [self selectedDOMRange];
    [range selectNodeContents:element];

    [range setStart:element offset:start];
    [range setEnd:element offset:end];
    
    [self setSelectedDOMRange:range affinity:NSSelectionAffinityDownstream];

}



#pragma mark -
#pragma mark manage IU

- (NSString *)IDOfCurrentIU{
    if( [currentNode isKindOfClass:[DOMHTMLElement class]] ){
        return [currentNode idName];
    }
    return nil;
}

- (DOMElement *)DOMElementAtPoint:(NSPoint)point{
    NSDictionary *dict  =[self elementAtPoint:point];
    DOMElement *element = [dict objectForKey:WebElementDOMNodeKey];
    return element;
}

- (NSString *)IUAtPoint:(NSPoint)point{
    
    DOMElement *domNode =[self DOMElementAtPoint:point];
    if(domNode){
        DOMHTMLElement *htmlElement =[self IUNodeAtCurrentNode:domNode];
        return htmlElement.idName;
    }
    
    return nil;
}


- (BOOL)isDOMTextAtPoint:(NSPoint)point{
    DOMElement *element = [self DOMElementAtPoint:point];
    if([element isKindOfClass:[DOMText class]]){
        return YES;
    }
    return NO;
}


- (DOMHTMLElement *)IUNodeAtCurrentNode:(DOMNode *)node{
    NSString *iuClass = ((DOMElement *)node).className;
    if([iuClass containsString:@"IUBox"]){
        return (DOMHTMLElement *)node;
    }
    else if ([node isKindOfClass:[DOMHTMLIFrameElement class]]){
        JDWarnLog(@"");
        return nil;
    }
    else if (node.parentNode == nil ){
        //can't find div node
        //- it can't be in IU model
        //- IU model : text always have to be in Div class
        //reach to html
        JDWarnLog(@"can't find IU node, reach to HTMLElement");
        return nil;
    }
    else {
        return [self IUNodeAtCurrentNode:node.parentNode];
    }
}

#pragma mark -
#pragma mark web policy

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element
    defaultMenuItems:(NSArray *)defaultMenuItems
{
    // disable right-click context menu
    return nil;
}

/*

- (BOOL)webView:(WebView *)webView shouldPerformAction:(SEL)action fromSender:(id)sender{
    JDWarnLog(@"");

    return [ super webView:webView shouldPerformAction:action fromSender:sender];
}

- (BOOL)webView:(WebView *)webView validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)item defaultValidation:(BOOL)defaultValidation{
    JDWarnLog(@"");

    return [super webView:webView validateUserInterfaceItem:item defaultValidation:defaultValidation];
}
- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request{
    JDWarnLog(@"");
    return [super webView:sender createWebViewWithRequest:request];
}
- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    [listener use];
}

- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    [listener use];
}
*/


@end
