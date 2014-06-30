//
//  IUTextController.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 20..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUTextController.h"
#import "IUCSS.h"

@interface IUTextController()

@property NSRange selectedRange;
@property NSMutableDictionary *rangeDict;
@property NSString *innerText;
@property DOMHTMLElement *currentNode;
@property NSMutableIndexSet *newlineIndexSet;
@end

@implementation IUTextController{
    BOOL textMode;
}

- (id)init{
    self = [super init];
    if(self){
        _cssDict = [NSMutableDictionary dictionary];
        _rangeDict = [NSMutableDictionary dictionary];
//        _newlineIndexSet = [NSMutableIndexSet indexSet];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"textEditMode" options:NSKeyValueObservingOptionInitial context:nil];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.innerText forKey:@"innerText"];
    [aCoder encodeObject:self.cssDict forKey:@"cssDict"];
    [aCoder encodeObject:self.rangeDict forKey:@"rangeDict"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        _innerText = [aDecoder decodeObjectForKey:@"innerText"];
        _cssDict = [[aDecoder decodeObjectForKey:@"cssDict"] mutableCopy];
        _rangeDict = [[aDecoder decodeObjectForKey:@"rangeDict"] mutableCopy];
//        _newlineIndexSet = [NSMutableIndexSet indexSet];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"textEditMode" options:NSKeyValueObservingOptionInitial context:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"textEditMode"];
}

- (id)copyWithZone:(NSZone *)zone{
    IUTextController *textController = [[IUTextController allocWithZone:zone] init];
    textController.innerText = [self.innerText copy];
    textController.cssDict = [[NSMutableDictionary alloc] initWithDictionary:_cssDict copyItems:YES];
    textController.rangeDict = [[NSMutableDictionary alloc] initWithDictionary:_rangeDict copyItems:YES];
//    textController.newlineIndexSet = [[NSMutableIndexSet alloc] initWithIndexSet:_newlineIndexSet];
    
    return textController;
}

- (NSArray *)fontNameArray{
    NSMutableArray *fontArray = [NSMutableArray array];
    for(IUCSS *css in _cssDict.allValues){
        NSString *fontName = [css valueForKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagFontName]];
        if(fontName != nil && [fontArray containsString:fontName] == NO){
            [fontArray addObject:fontName];
        }
                              
    }
    return fontArray;
}

#pragma mark call by IU

- (void)selectTextRange:(NSRange)range htmlNode:(DOMHTMLElement *)node{

    [self willChangeValueForKey:@"fontColor"];
    [self willChangeValueForKey:@"fontName"];
    [self willChangeValueForKey:@"bold"];
    [self willChangeValueForKey:@"italic"];
    [self willChangeValueForKey:@"underline"];
    [self willChangeValueForKey:@"link"];
    [self willChangeValueForKey:@"fontSize"];

    _selectedRange = range;
    _currentNode = node;
    _innerText = node.innerText;

    [self checkRange];
    
    [self didChangeValueForKey:@"fontColor"];
    [self didChangeValueForKey:@"fontName"];
    [self didChangeValueForKey:@"bold"];
    [self didChangeValueForKey:@"italic"];
    [self didChangeValueForKey:@"underline"];
    [self didChangeValueForKey:@"link"];
    [self didChangeValueForKey:@"fontSize"];

}
- (void)textEditModeDidChange:(NSDictionary *)change{
    textMode = [[NSUserDefaults  standardUserDefaults] boolForKey:@"textEditMode"];
    if(textMode == NO){
        [self deselectText];
    }
}
- (void)deselectText{
    [self willChangeValueForKey:@"fontColor"];
    [self willChangeValueForKey:@"fontName"];
    [self willChangeValueForKey:@"bold"];
    [self willChangeValueForKey:@"italic"];
    [self willChangeValueForKey:@"underline"];
    [self willChangeValueForKey:@"link"];
    [self willChangeValueForKey:@"fontSize"];

    [self css];
    
    [self didChangeValueForKey:@"fontColor"];
    [self didChangeValueForKey:@"fontName"];
    [self didChangeValueForKey:@"bold"];
    [self didChangeValueForKey:@"italic"];
    [self didChangeValueForKey:@"underline"];
    [self didChangeValueForKey:@"link"];
    [self didChangeValueForKey:@"fontSize"];
}



- (void)insertNewLine:(NSRange)range htmlNode:(DOMHTMLElement *)node{
    [self selectTextRange:range htmlNode:node];

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
    
    
    NSMutableArray *existIDArray = [NSMutableArray array];
    
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
        
        [existIDArray addObject:element.idName];
    }
    
    for(NSString *identifier in _cssDict.allKeys){
        if([existIDArray containsString:identifier] == NO){
            [_cssDict removeObjectForKey:identifier];
            [_rangeDict removeObjectForKey:identifier];
            [self.textDelegate removeTextCSSIdentifier:identifier];

        }
    }
   
}

#pragma mark - manage css dict

- (NSString *)newIdentifier{
    //make new identifier;
    for(int i=0; ; i++){
        NSString *identifier = [NSString stringWithFormat:@"%@TNode%d", _textDelegate.identifierForTextController , i];
        if( [_cssDict.allKeys containsObject:identifier] == NO){
            return identifier;
        }
    }
    return nil;
}

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
   
    
    return nil;
}

- (IUCSS *)cssOfCurrentRange{
    
    NSString *identifier = [self identifierOfCurrentRange];
    
    //현재 선택된 range랑 같은 range로 이미 만들어져 있음.
    if(identifier != nil && [_cssDict.allKeys containsObject:identifier]){
        return [_cssDict objectForKey:identifier];
    }
    else{
        //부분 변화 없이 전체 change
        return self.textDelegate.css;
    }
}

- (NSArray *)cssArraysOfCurrentRange{
    NSMutableArray *cssArray = [NSMutableArray array];
    
    BOOL intersectionFlag = false;
    //기존에 있던 range와 동일한 range가 선택되었을 경우
    for(NSString *identifier in _rangeDict){
        NSRange range = [[_rangeDict objectForKey:identifier] rangeValue];
        if(NSEqualRanges(range, _selectedRange)){
            [cssArray addObject:identifier];
            return cssArray;
        }
        if(NSIntersectionRange(range, _selectedRange).length > 0){
            intersectionFlag = YES;
        }
    }
    
    //rangeDict가 empty일 때 or 기존에 rangedict와 겹치는 부분이 하나도 없음! hooray!
    if(intersectionFlag == NO){
        NSString *nIdentifier = [self makeNewCSS:_selectedRange copyWithIdentifier:nil];
        [cssArray addObject:nIdentifier];
        return cssArray;

    }

    
    //기존에 있는 rangedict와 일부분 겹침, 새롭게 구역을 나누어 주어야 함.
    BOOL newRangeFlag = false, foundRangeFlag;
    NSUInteger startIndex;
    NSMutableDictionary *copiedDict = [_rangeDict mutableCopy];

    
    for(NSUInteger index = _selectedRange.location ; index < NSMaxRange(_selectedRange); index++){
        NSRange range;
        foundRangeFlag = NO;
        NSString *currentIdentifier;
        
        for(NSString *identifier in copiedDict){
            range = [[copiedDict objectForKey:identifier] rangeValue];
            if(NSLocationInRange(index, range) == YES){
                foundRangeFlag = YES;
                currentIdentifier = identifier;
                break;
            }
        }
        
        //새로운 range 가 완성
        if(newRangeFlag == YES  && foundRangeFlag){
            newRangeFlag = false;
            //새로운 css할당
            NSString *nIdentifer = [self makeNewCSS:NSMakeRange(startIndex, index - startIndex) copyWithIdentifier:nil];
            [cssArray addObject:nIdentifer];
        }
        
        //intersection 발견
        if(foundRangeFlag){
            NSRange intersectionRange = NSIntersectionRange(range, _selectedRange);
            
            //현재 위치보다 전부터 겹침. 앞에껀 range를 바껴줌. 선택되지는 않음.
            if(range.location < index){
                NSRange modifiedRange = NSMakeRange(range.location, index - range.location);
                [_rangeDict setObject:[NSValue valueWithRange:modifiedRange] forKey:currentIdentifier];
                [copiedDict removeObjectForKey:currentIdentifier];
                
                NSString *nIdentifer = [self makeNewCSS:NSMakeRange(index, intersectionRange.length) copyWithIdentifier:currentIdentifier];
                [cssArray addObject:nIdentifer];
                index = index + intersectionRange.length -1;
            }
            else{
                NSRange modifiedRange = NSMakeRange(range.location, intersectionRange.length);
                [_rangeDict setObject:[NSValue valueWithRange:modifiedRange] forKey:currentIdentifier];
                [cssArray addObject:currentIdentifier];
                index = index + intersectionRange.length -1;
            }
            
            //range바깥에도 dict가 있었음. 새로 만들어줘야함.
            if(NSMaxRange(_selectedRange) < NSMaxRange(range)){
                //바깥에 있는 range는 새로운 블락으로 할당되지만, 현재 선택되지는 않음.
                //end of range
                [self makeNewCSS:NSMakeRange(NSMaxRange(_selectedRange), NSMaxRange(range) - NSMaxRange(_selectedRange)) copyWithIdentifier:currentIdentifier];
                break;
            }

        }
        //현재 index에 range dict 가 없을 때
        //새로운 range를 만들어야함!!
        else{
            if(newRangeFlag == false){
                newRangeFlag = true;
                startIndex = index;
            }
        }
    }
    
    return cssArray;
}

- (NSString *)makeNewCSS:(NSRange)range copyWithIdentifier:(NSString *)copyIdentifier{
    NSString *identifier = [self newIdentifier];

    //새로운 range임
    IUCSS *css;
    
    if(copyIdentifier){
        IUCSS *copiedCSS = [_cssDict objectForKey:copyIdentifier];
        css = [copiedCSS copy];
    }
    else{
         css = [[IUCSS alloc] init];
        [self setDefaultTextAttribute:css];
    }
    css.delegate = self;
    [_cssDict setObject:css forKey:identifier];
    [_rangeDict setObject:[NSValue valueWithRange:range] forKey:identifier];
    return identifier;
}

- (BOOL)hasCSSForCurrentRange{
    for(NSString *identifier in _rangeDict.allKeys){
        NSRange range = [[_rangeDict objectForKey:identifier] rangeValue];
        if(NSEqualRanges(range, _selectedRange)){
            return YES;
        }
    }
    return NO;
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
    IUCSS *css;
    
    if(textMode){
        css = [self cssOfCurrentRange];
    }
    else{
        css = [self.textDelegate css];
    }
    return css;
}

- (void)updateTextCollectionWithIdentifier:(NSString *)identifier{
    [self.textDelegate updateTextHTML];
    [self.textDelegate updateTextCSS:_cssDict[identifier] identifier:identifier];
   // [self.textDelegate updateTextRangeByID:[self identifierOfCurrentRange]];

}

- (void)setTextTag:(IUCSSTag)tagName value:(id)value{

    //css전체에 적용하는 경우
    if(textMode == NO || _innerText == nil ||
       _innerText.length == 0 || _selectedRange.length == 0 ||
       _selectedRange.length == _innerText.length
       ){
        IUCSS *css = [self.textDelegate css];
        [css setValue:value forTag:tagName];
        return;
    }
    
    //부분적용
    NSString *startId, *endId;
    NSRange minRange = NSMakeRange(_innerText.length, _innerText.length);
    NSRange maxRange = NSMakeRange(0, 0);
    NSArray *selectedArray = [self cssArraysOfCurrentRange];
    for(NSString *identifier in selectedArray){
        IUCSS *css = [_cssDict objectForKey:identifier];
        [css setValue:value forTag:tagName];
        [self updateTextCollectionWithIdentifier:identifier];
        
        NSRange range = [[_rangeDict objectForKey:identifier] rangeValue];
        if(range.location < minRange.location){
            minRange = range;
            startId = identifier;
        }
        if(range.location + range.length > maxRange.location + maxRange.length){
            maxRange = range;
            endId = identifier;
        }
        
    }
    
    [self.textDelegate updateTextRangeFromID:startId toID:endId];
}

- (void)setDefaultTextAttribute:(IUCSS *)css{
    [css setValue:@"Arial" forTag:IUCSSTagFontName forWidth:IUCSSMaxViewPortWidth];
    [css setValue:@(12) forTag:IUCSSTagFontSize forWidth:IUCSSMaxViewPortWidth];
}


#pragma mark - connect to textVC

- (void)setFontName:(NSColor *)fontName{
    [self setTextTag:IUCSSTagFontName value:fontName];
}
- (NSString *)fontName{
    return self.css.assembledTagDictionary[IUCSSTagFontName];

}

- (void)setFontColor:(NSColor *)fontColor{
    [self setTextTag:IUCSSTagFontColor value:fontColor];
}

- (NSColor *)fontColor{
    return self.css.assembledTagDictionary[IUCSSTagFontColor];
}

- (void)setBold:(BOOL)bold{
    [self setTextTag:IUCSSTagFontWeight value:@(bold)];
}
- (BOOL)bold{
    return [self.css.assembledTagDictionary[IUCSSTagFontWeight] boolValue];

}

- (void)setItalic:(BOOL)italic{
    [self setTextTag:IUCSSTagFontStyle value:@(italic)];

    
}
- (BOOL)italic{
    return [self.css.assembledTagDictionary[IUCSSTagFontStyle] boolValue];

}

- (void)setUnderline:(BOOL)underline{
    
    [self setTextTag:IUCSSTagTextDecoration value:@(underline)];
}
- (BOOL)underline{
    return [self.css.assembledTagDictionary[IUCSSTagTextDecoration] boolValue];

}

- (void)setFontSize:(int)fontSize{
    [self setTextTag:IUCSSTagFontSize value:@(fontSize)];
}

- (int)fontSize{
    return [self.css.assembledTagDictionary[IUCSSTagFontSize] intValue];
}

- (void)setLink:(NSString *)link{
    [self setTextTag:IUCSSTagTextLink value:link];
}

- (NSString *)link{
    return self.css.assembledTagDictionary[IUCSSTagTextLink];
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
    if(_innerText == nil || _innerText.length ==0){
        return nil;
    }
    NSMutableString *code = [NSMutableString string];
    
    //find index to insert span tag
    NSDictionary *setDict = [self indexSet];
    NSIndexSet *startSet = [setDict objectForKey:@"start"];
    NSIndexSet *endSet = [setDict objectForKey:@"end"];
    NSUInteger startIndex = [startSet firstIndex];
    NSUInteger endIndex = [endSet firstIndex];
//    NSUInteger newlineIndex = [_newlineIndexSet firstIndex];
    NSUInteger currentIndex =0;
    [code appendString:@"<p>"];
    while(1){
        NSUInteger copyIndex;
        NSMutableString *appendTag = [NSMutableString string];
        
        /*
        if(newlineIndex == currentIndex){
            [code appendString:@"<br>"];
            newlineIndex = [_newlineIndexSet indexGreaterThanIndex:newlineIndex];
        }
         */
        
        if(endIndex == currentIndex){
            //startIndex == endIndex
            copyIndex = startIndex;
            //append end tag
            for(int i=0; i<[self countOfEndTagAtLocation:endIndex]; i++){
                [appendTag appendString:@"</span>"];
            }
            endIndex = [endSet indexGreaterThanIndex:endIndex];
        }
        
        if(startIndex == currentIndex){
            //append start tag
            copyIndex = startIndex;
            NSArray *array = [self identifierOfIndex:startIndex];
            for(NSString *identifier in array){
                [appendTag appendFormat:@"<span id='%@' class='%@'>",identifier, identifier];
            }
            startIndex = [startSet indexGreaterThanIndex:startIndex];
        }
        
        [code appendString:appendTag];
        if(_innerText.length > currentIndex){
            [code appendString:[_innerText substringFromIndex:currentIndex toIndex:currentIndex+1]];
        }
        currentIndex++;
        
        if(currentIndex > _innerText.length +1 ){
            break;
        }
        
        
    }
    [code replaceOccurrencesOfString:@"\n" withString:@"<br>" options:0 range:NSMakeRange(0, code.length)];
    [code appendString:@"</p>"];
    return code;
}
@end
