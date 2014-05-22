//
//  IUTextController.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 20..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUTextController.h"

@interface IUTextController()

@property NSRange selectedRange;
@property NSMutableDictionary *rangeDict;
@property NSString *innerText, *innerHTML;
@property DOMHTMLElement *currentNode;
@end

@implementation IUTextController{
}

- (id)init{
    self = [super init];
    if(self){
        _cssDict = [NSMutableDictionary dictionary];
        _rangeDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.innerText forKey:@"innerText"];
    [aCoder encodeObject:self.innerHTML forKey:@"innerHTML"];
    [aCoder encodeObject:self.cssDict forKey:@"cssDict"];
    [aCoder encodeObject:self.rangeDict forKey:@"rangeDict"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        _innerText = [aDecoder decodeObjectForKey:@"innerText"];
        _innerHTML = [aDecoder decodeObjectForKey:@"innerHTML"];

        _cssDict = [[aDecoder decodeObjectForKey:@"cssDict"] mutableCopy];
        _rangeDict = [[aDecoder decodeObjectForKey:@"rangeDict"] mutableCopy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IUTextController *textController = [[IUTextController allocWithZone:zone] init];
    textController.innerText = [self.innerText copy];
    textController.cssDict = [[NSMutableDictionary alloc] initWithDictionary:_cssDict copyItems:YES];
    textController.rangeDict = [[NSMutableDictionary alloc] initWithDictionary:_rangeDict copyItems:YES];
    
    return textController;
}

#pragma mark call by IU

- (void)selectTextRange:(NSRange)range startContainer:(NSString *)startContainer endContainer:(NSString *)endContainer htmlNode:(DOMHTMLElement *)node{
    
    _selectedRange = range;
    _currentNode = node;
    _innerText = node.innerText;
    _innerHTML = node.innerHTML;

    [self checkRange];
}

- (BOOL)isManagedElement{
    DOMHTMLElement *element = (DOMHTMLElement *)[_currentNode.childNodes item:0];
    if([element isKindOfClass:[DOMHTMLParagraphElement class]]){
        return YES;
    }
    return NO;
}

- (void)checkRange{
    
    //한번도 부분 수정이 일어나지 않은 경우에는 return
    if([self isManagedElement] == NO){
        return;
    }
    
    NSString *innerText = [_currentNode innerText];
    unsigned int totalLength = 0;
    DOMHTMLElement *pElement = (DOMHTMLElement *)[_currentNode.childNodes item:0];
    for(int i =0; i<[pElement.childNodes length]; i++){
        DOMHTMLElement * element = (DOMHTMLElement *)[pElement.childNodes item:i];
        
        //ignore br element
        if([element isKindOfClass:[DOMHTMLBRElement class]]){
            continue;
        }
        NSRange range = [[_rangeDict objectForKey:element.idName] rangeValue];
        
        //update length
        int textLength = (int)element.innerText.length;
        if(range.length != textLength){
            range.length = textLength;
        }
        
        //update location
        NSRange findRange = NSMakeRange(totalLength, innerText.length - totalLength);
        NSRange startRange  = [innerText rangeOfString:element.innerText options:0 range:findRange];
        if(range.location != startRange.location){
            range.location = startRange.location;
        }
        
        totalLength += textLength;
    }
   
}

#pragma mark - manage css dict


- (NSString *)identifierOfCurrentRange{

    for(NSString *identifier in _rangeDict.allKeys){
        NSRange range = [[_rangeDict objectForKey:identifier] rangeValue];
        
        //no selection - move cursur
        if(NSLocationInRange(_selectedRange.location, range)){
            return identifier;
        }
        //select - can possible change
        else if(NSEqualRanges(_selectedRange, range)){
            return identifier;
        }
    }
    //make new identifier;
    for(int i=0; ; i++){
        NSString *identifier = [NSString stringWithFormat:@"%@TNode%d", _textDelegate.identifierForTextController , i];
        if( [_cssDict.allKeys containsObject:identifier] == NO){
            return identifier;
        }
    }
    
    
    return nil;
}

- (IUCSS *)cssOfCurrentRange{
    
    NSString *identifier = [self identifierOfCurrentRange];
    
    //부분 변화 없이 전체 change
    if(_cssDict.allKeys.count == 0 && _selectedRange.length ==0){
        return self.textDelegate.css;
    }
    
    //현재 선택된 range랑 같은 range로 이미 만들어져 있음.
    if( [_cssDict.allKeys containsObject:identifier]){
        return [_cssDict objectForKey:identifier];
    }
    else{
        //새로운 range임
        IUCSS *css = [[IUCSS alloc] init];
        css.delegate = self;
        [_cssDict setObject:css forKey:identifier];
        [_rangeDict setObject:[NSValue valueWithRange:_selectedRange] forKey:identifier];
        
        return css;
    }
}

#pragma mark - iu css delegate
-(BOOL)CSSShouldChangeValue:(id)value forTag:(NSString *)tag forWidth:(NSInteger)width{
    return YES;
}

-(void)startGrouping{
    
}
-(void)CSSUpdated:(IUCSSTag)tag forWidth:(NSInteger)width isHover:(BOOL)isHover{
    
}
-(void)endGrouping{
    
}

-(void)setEditWidth:(NSInteger)width{
    for(NSString *identifier in _cssDict.allKeys){
        IUCSS *css = [_cssDict objectForKey:identifier];
        [css setEditWidth:width];
    }
}

#pragma mark - set font attributes

- (IUCSS *)css{
    IUCSS *css = [self cssOfCurrentRange];
    return css;
}

- (void)setFontColor:(NSColor *)fontColor{
    [self.css setValue:fontColor forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagFontColor]];
    [self.textDelegate updateTextHTML];
    [self.textDelegate updateTextCSS:self.css identifier:[self identifierOfCurrentRange]];
}

- (NSColor *)fontColor{
    return self.css.assembledTagDictionary[IUCSSTagFontColor];
}

- (void)setBold:(BOOL)bold{
    
}

- (void)setItalic:(BOOL)italic{
    
}

- (void)setUnderline:(BOOL)underline{
    
}
- (void)setLink:(NSString *)link{
    
}

- (void)setFontSize:(int)fontSize{
    
}

- (void)setTextAlign:(IUAlign)textAlign{
    
}

#pragma mark - css

#pragma mark - html

- (NSDictionary *)indexSet{
    NSMutableIndexSet *startSet = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *endSet = [NSMutableIndexSet indexSet];
    for( NSValue *value in _rangeDict.allValues){
        NSRange range = [value rangeValue];
        [startSet addIndex:range.location];
        [endSet addIndex:(range.length + range.location)];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:startSet forKey:@"start"];
    [dict setObject:endSet forKey:@"end"];
    return dict;
}

- (NSArray *)identifierOfIndex:(NSUInteger)index{
    NSMutableArray *array = [NSMutableArray array];
    for( NSString *identifier in _rangeDict.allKeys){
        NSRange range = [[_rangeDict objectForKey:identifier] rangeValue];
        if(range.location == index){
            [array addObject:identifier];
        }
    }
    return array;
}
- (NSUInteger)countOfEndTagAtLocation:(NSUInteger)location{
    NSUInteger count =0;
    for( NSString *identifier in _rangeDict.allKeys){
        NSRange range = [[_rangeDict objectForKey:identifier] rangeValue];
        if(range.length + range.location == location){
            count++;
        }
    }
    return count;
}

- (NSString *)textHTML{
    if(_cssDict.allKeys.count == 0){
        return _innerHTML;
    }
    NSMutableString *code = [NSMutableString string];
    
    //find index to insert span tag
    NSDictionary *setDict = [self indexSet];
    NSIndexSet *startSet = [setDict objectForKey:@"start"];
    NSIndexSet *endSet = [setDict objectForKey:@"end"];
    NSUInteger startIndex = [startSet firstIndex];
    NSUInteger endIndex = [endSet firstIndex];
    NSUInteger currentIndex =0;
    BOOL endflag = false;
    [code appendString:@"<p>"];
    while(1){
        NSUInteger copyIndex;
        NSMutableString *appendTag = [NSMutableString string];
        
        if(startIndex < endIndex){
            //append start tag
            copyIndex = startIndex;
            NSArray *array = [self identifierOfIndex:startIndex];
            for(NSString *identifier in array){
                [appendTag appendFormat:@"<span id='%@' class='%@'>",identifier, identifier];
            }
            startIndex = [startSet indexGreaterThanIndex:startIndex];
        }
        else if(startIndex > endIndex
                || startIndex == NSNotFound){
            copyIndex = endIndex;
            
            //append end tag
            for(int i=0; i<[self countOfEndTagAtLocation:endIndex]; i++){
                [appendTag appendString:@"</span>"];
            }
            endIndex = [endSet indexGreaterThanIndex:endIndex];
            if(endIndex == NSNotFound){
                endflag = true;
            }
        }
        else{
            //startIndex == endIndex
            copyIndex = startIndex;
            //append end tag
            for(int i=0; i<[self countOfEndTagAtLocation:endIndex]; i++){
                [appendTag appendString:@"</span>"];
            }
            endIndex = [endSet indexGreaterThanIndex:endIndex];
            
            //append start tag
            NSArray *array = [self identifierOfIndex:startIndex];
            for(NSString *identifier in array){
                [appendTag appendFormat:@"<span id='%@' class='%@'>",identifier, identifier];
            }
            startIndex = [startSet indexGreaterThanIndex:startIndex];
        }
    
        [code appendString:[_innerText substringFromIndex:currentIndex toIndex:copyIndex]];
        currentIndex = copyIndex;
        [code appendString:appendTag];
        
        if(endflag){
            [code appendString:[_innerText substringFromIndex:copyIndex]];
            break;
        }
        
    }
    [code appendString:@"</p>"];
    return code;
}
@end
