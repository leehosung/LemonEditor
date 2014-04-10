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
#import "IUDefinition.h"
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
        [self setEditable:NO];
        
        [self registerForDraggedTypes:@[(id)kUTTypeIUType]];
    }
    
    return self;
    
}

- (BOOL)isFlipped{
    return YES;
}

#pragma mark -
#pragma mark Event

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent{
    

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
- (BOOL)webView:(WebView *)webView shouldDeleteDOMRange:(DOMRange *)range{

    DOMNode *container = range.startContainer;
    if([container isKindOfClass:[DOMText class]]){
        return YES;
    }
//    DOMHTMLElement *iuNode = [self IUNodeAtCurrentNode:container];
    //this is not deleting text , remove IU
    
[((LMCanvasVC *)self.delegate) removeSelectedIUs];
    
    return YES;
}


#pragma mark -
#pragma mark mouse operation


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
    
    NSData *newData = [pBoard dataForType:(id)kUTTypeIUType];
    IUBox *newIU = [NSKeyedUnarchiver unarchiveObjectWithData:newData];
    if(newIU){
        NSString *parentIUID = [self IUAtPoint:convertedPoint];
        if(parentIUID){
            [((LMCanvasVC *)(self.delegate)) makeNewIU:newIU atPoint:convertedPoint atIU:parentIUID];
            return YES;
        }
    }
    
    return NO;
    JDTraceLog( @"[IU:%@], dragPoint(%.1f, %.1f)", newIU.htmlID, dragPoint.x, dragPoint.y);
}


- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags{
    //whem mouse move, save current element!
    currentNode = [elementInformation objectForKey:WebElementDOMNodeKey];
    
    if([currentNode isKindOfClass:[DOMText class]]){
        currentNode = [self textParentIUElement:currentNode];
    }
    
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


#pragma mark -
#pragma mark text

- (DOMHTMLElement *)textParentIUElement:(DOMNode *)node{
    NSString *iuClass = ((DOMElement *)node.parentNode).className;
    if([iuClass containsString:@"IUBox"]){
        return (DOMHTMLElement *)node.parentNode;
    }
    else if ([node.parentNode isKindOfClass:[DOMHTMLHtmlElement class]] ){
        //can't find div node
        //- it can't be in IU model
        //- IU model : text always have to be in Div class
        //reach to html
        assert(1);
        return nil;
    }
    else {
        return [self textParentIUElement:node.parentNode];
    }
}

- (BOOL)webView:(WebView *)webView shouldInsertText:(NSString *)text replacingDOMRange:(DOMRange *)range givenAction:(WebViewInsertAction)action{
    
    DOMNode *node = range.startContainer;
    BOOL isWritable =  NO;
    
    
    //check to insert Text
    if([node isKindOfClass:[DOMText class] ]){
        isWritable = YES;
    }
    else {
        if([node isNotEqualTo:currentNode]){
            return NO;
        }
        NSString *writableValue = [((DOMElement *)node) getAttribute:@"isWritable"];
        if(writableValue){
            isWritable = [writableValue boolValue];
        }
    }

    //insert Text
    if (isWritable){
        JDTraceLog( @"insert Text : %@", text);
        DOMHTMLElement *insertedTextNode = [self textParentIUElement:node];
        
                if(insertedTextNode != nil){
            [((LMCanvasVC *)(self.delegate)) updateHTMLText:insertedTextNode.innerHTML atIU:insertedTextNode.idName];
            return YES;
        }
    }
    return NO;
}
- (BOOL)webView:(WebView *)webView shouldApplyStyle:(DOMCSSStyleDeclaration *)style toElementsInDOMRange:(DOMRange *)range{
    
    
    JDTraceLog( @"insert CSS : %@", style.cssText);
    DOMHTMLElement *insertedTextNode = [self textParentIUElement:range.startContainer];
    
    if(insertedTextNode != nil){
        [((LMCanvasVC *)(self.delegate)) updateHTMLText:insertedTextNode.innerHTML atIU:insertedTextNode.idName];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isOneIUSTextelection:(DOMRange *)range{
    DOMNode *startContainer = range.startContainer;
    if([startContainer isKindOfClass:[DOMText class]]){
        startContainer = [self textParentIUElement:startContainer];
    }
    DOMNode *ancestorContainer = range.commonAncestorContainer;
    if([ancestorContainer isKindOfClass:[DOMText class]]){
        ancestorContainer = [self textParentIUElement:ancestorContainer];
    }
    
    if ([startContainer isEqualTo:ancestorContainer]){
        return YES;
    }
    else{
        return NO;
    }
    
}

- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange toDOMRange:(DOMRange *)proposedRange affinity:(NSSelectionAffinity)selectionAffinity stillSelecting:(BOOL)flag{

    if([self isOneIUSTextelection:proposedRange]){
        NSArray * selectednames = ((LMCanvasVC *)(self.delegate)).controller.selectedIdentifiers;
        DOMHTMLElement *proposedNode;
        if([proposedRange.startContainer isKindOfClass:[DOMText class]]){
            proposedNode = [self textParentIUElement:proposedRange.startContainer];
        }
        else{
            proposedNode = (DOMHTMLElement *)proposedRange.startContainer;
        }
        
        if(selectednames.count == 1 && [selectednames[0] isEqualToString:proposedNode.idName]){
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
    else if ([node.parentNode isKindOfClass:[DOMHTMLHtmlElement class]] ){
        //can't find div node
        //- it can't be in IU model
        //- IU model : text always have to be in Div class
        //reach to html
        JDErrorLog(@"can't find IU node, reach to HTMLElement");
        assert(1);
        return nil;
    }
    else {
        return [self IUNodeAtCurrentNode:node.parentNode];
    }
}




@end
