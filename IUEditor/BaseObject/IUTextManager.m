//
//  IUTextManager.m
//  IUEditor
//
//  Created by jd on 4/16/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUTextManager.h"

@interface TextIndexInfo : NSObject <NSCopying>
@property NSUInteger index;
@property (copy) id  info;
@end

@implementation TextIndexInfo{
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeFromObject:self withProperties:[TextIndexInfo properties]];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        [aDecoder decodeToObject:self withProperties:[TextIndexInfo properties]];
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone{
    TextIndexInfo *info = [[TextIndexInfo allocWithZone:zone] init];
    info.index = _index;
    info.info = [_info copy];
    return info;
}

-(NSString*)description{
    NSString *d = [super description];
    return [NSString stringWithFormat:@"%@ %ld:%@", d, _index, [_info description]];
}
@end

@interface IUTextManager()

@property NSMutableArray *fontInfos;
@property NSMutableDictionary *fontSizeInfoCollection;
@property NSMutableString *text;

@property NSInteger preparedFontSize;
@property NSString *preparedFontName;

@end

@implementation IUTextManager{
    
    NSInteger _cursorLocationInText;
}

- (id)init{
    self = [super init];
    _fontInfos = [NSMutableArray array];
    _text = [NSMutableString string];
    _fontSizeInfoCollection = [NSMutableDictionary dictionary];
    _preparedFontSize = 25;

    [self setValue:@"Helvatica" forRange:NSZeroRange inInfos:_fontInfos];
    [_fontSizeInfoCollection setObject:[NSMutableArray array] forKey:@(IUCSSMaxViewPortWidth)];
    [self setValue:@(25) forRange:NSZeroRange inInfos:_fontSizeInfoCollection[@(IUCSSMaxViewPortWidth)]];
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeFromObject:self withProperties:[IUTextManager properties]];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        [aDecoder decodeToObject:self withProperties:[IUTextManager propertiesWithOutProperties:@[@"fontInfos", @"text", @"fontSizeInfoCollection"]]];
        _fontInfos = [[aDecoder decodeObjectForKey:@"fontInfos"] mutableCopy];
        _text = [[aDecoder decodeObjectForKey:@"text"] mutableCopy];
        _fontSizeInfoCollection = [[aDecoder decodeObjectForKey:@"fontSizeInfoCollection"] mutableCopy];
    }
    return self;
}

- (TextIndexInfo *)infoObjectAtArray:(NSArray*)infoArray beforeIndex:(NSInteger)index{
    if ([infoArray count] == 0) {
        return nil;
    }
    int i=0;
    for (; i<[infoArray count]; i++) {
        TextIndexInfo *info = [infoArray objectAtIndex:i];
        if (info.index>=index) {
            break;
        }
    }
    if (i == 0) {
        assert(0);
    }
    return [infoArray objectAtIndex:i - 1];
}

- (TextIndexInfo *)infoObjectAtArray:(NSArray*)infoArray beforeOrEqualIndex:(NSInteger)index{
    if ([infoArray count] == 0) {
        return nil;
    }
    int i=0;
    for (; i<[infoArray count]; i++) {
        TextIndexInfo *info = [infoArray objectAtIndex:i];
        if (info.index>index) {
            break;
        }
    }
    if (i == 0) {
        //media query의 경우 i가 아예 0일수도.
        return nil;
    }
    return [infoArray objectAtIndex:i - 1];
}


- (TextIndexInfo *)infoObjectAtArray:(NSArray*)infoArray atIndex:(NSUInteger)index{
    for (TextIndexInfo *info in infoArray) {
        if (info.index == index) {
            return info;
        }
    }
    return  nil;
}



//Need to update (algorithm)
- (NSArray*)infoObjectsAtArray:(NSArray*)infoArray ofRange:(NSRange)range{
    NSUInteger endIndex = range.location + range.length -1;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(TextIndexInfo* evaluatedObject, NSDictionary *bindings) {
        if (evaluatedObject.index >= range.location && evaluatedObject.index <= endIndex){
            return YES;
        }
        return NO;
    }];
    return [infoArray filteredArrayUsingPredicate:predicate];
}

- (void)sortInfoArray:(NSMutableArray*)infoArray{
    NSSortDescriptor *d = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [infoArray sortUsingDescriptors:@[d]];
}

- (void)setValue:(id)value forRange:(NSRange)range inInfos:(NSMutableArray*)infos{
    //아무것도 없을시
    if (_text.length == 0) {
        assert(range.length == 0);
        assert(range.location == 0);
        TextIndexInfo *info = [[TextIndexInfo alloc] init];
        info.info = value;
        [infos addObject:info];
        return;
    }
    
    NSMutableArray *infosInRange = [[self infoObjectsAtArray:infos ofRange:range] mutableCopy];
    if ([infosInRange count]) {
        TextIndexInfo *nextInfo = [self infoObjectAtArray:infos atIndex:range.location + range.length];
        if (nextInfo == nil) {
            // range 안에 뭔가가 있으면 last Info를 민다
            TextIndexInfo *lastInfoInRange = [[self infoObjectsAtArray:infos ofRange:range] lastObject];
            if (lastInfoInRange) {
                lastInfoInRange.index = range.location + range.length;
                [infosInRange removeObject:lastInfoInRange];
                [infos removeObjectsInArray:infosInRange];
            }
        }
    }
    else {
        // range 안에 없으면 range 전에 것을 카피하여 바로 뒤에 셋.
        // range가 끝까지 가버리면 더 이상 카피하지 않음
        if (range.location + range.length < [_text length]) {
            TextIndexInfo *lastInfo = [self infoObjectAtArray:infos beforeIndex:range.location];
            if (lastInfo) {
                // media query의 경우 lastInfo가 없을 수도 있음.
                TextIndexInfo *newInfo = [[TextIndexInfo alloc] init];
                newInfo.info = lastInfo.info;
                newInfo.index = range.location + range.length;
                [infos addObject:newInfo];
            }
        }
        else if (range.location + range.length > [_text length]){
            assert(0);
        }
    }
    
    TextIndexInfo *info = [[TextIndexInfo alloc] init];
    info.index = range.location;
    info.info = value;
    [infos addObject:info];
    [self sortInfoArray:infos];
}

- (void)setFont:(NSString*)name atRange:(NSRange)range{
    [self setValue:name forRange:range inInfos:_fontInfos];
}

- (void)setFontSize:(NSInteger)size atRange:(NSRange)range{
    //만약 text가 있는 상태에서 range.location 이 zero면 잘못 들어온거
    if (range.length == 0 && [_text length] > 0) {
        [NSException raise:@"RangeLength" format:@"Range Length is zero"];
    }
    NSMutableArray *fontSizeInfos = [_fontSizeInfoCollection objectForKey:@(_editViewPortWidth)];
    if (fontSizeInfos == nil) {
        //디폴트를 카피해온다
        NSArray *defaultFontSizes = [_fontSizeInfoCollection objectForKey:@(IUCSSMaxViewPortWidth)];
        fontSizeInfos = [[NSMutableArray alloc] initWithArray:defaultFontSizes copyItems:YES];
        [_fontSizeInfoCollection setObject:fontSizeInfos forKey:@(_editViewPortWidth)];
    }
    [self setValue:@(size) forRange:range inInfos:fontSizeInfos];
}

- (void)setLink:(NSString*)url atRange:(NSRange)range{
    
}
- (void)setBoldAtRange:(NSRange)range{
    
}
- (void)setUnderbarAtRange:(NSRange)range{
    
}
- (void)setItalicAtRange:(NSRange)range{
    
}
- (void)insertString:(NSString*)string atRange:(NSRange)range{
    
}

- (void)setColor:(NSColor*)color atRange:(NSRange)range{
    
}

- (void)moveInfoArray:(NSArray*)infoArray from:(NSInteger)index distance:(NSInteger)distance{
    [infoArray enumerateObjectsUsingBlock:^(TextIndexInfo* obj, NSUInteger idx, BOOL *stop) {
        if (obj.index >= index){
            obj.index += distance;
        }
    }];
    [self sortInfoArray:_fontInfos];
}


- (void)deleteInfoArray:(NSMutableArray*)array atRange:(NSRange)range{
    // string의 끝까지 지울 경우 : 그냥 범위안을 다 지운다.
    // string의 끝까지 지우지 않을 경우 + Range 밖 처음의 Info가 바로 따라 붙을 경우 : 범위안을 다 지운다.
    // string의 끝까지 지우지 않을 경우 + Range 밖 처음의 Info가 떨어져 있을경우 : 마지막 Info를 뒤로 밀어둔다.
    JDTraceLog(@"%@", _text);
    if(_text.length >= range.location + range.length){
        [JDLogUtil alert:@"한글 문자를 입력하기 위해서는 Preference에서 '한글입력기'를 체크해주세요"];
        return;
    };

    NSArray *deleteArray = [self infoObjectsAtArray:array ofRange:range];
    TextIndexInfo *lastInfo = [deleteArray lastObject];
    [array removeObjectsInArray:deleteArray];
    
    if ([_text length] > range.location + range.length ) {
        TextIndexInfo *info = [self infoObjectAtArray:array atIndex:range.location + range.length];
        if (info.index > range.location + range.length) {
            //뒤로 밀어줘야할 경우
            lastInfo.index = range.location + range.length - 1;
            [array addObject:lastInfo];
        }
    }
}

- (void)removeDuplicatedInfo:(NSMutableArray*)array{
    NSInteger count = array.count - 1;
    for (NSInteger i=0; i<count; i++) {
        TextIndexInfo *info = [array objectAtIndex:i];
        TextIndexInfo *nextInfo = [array objectAtIndex:i+1];
        if ([info.info isEqualToString:nextInfo.info]) {
            i++;
            [array removeObject:nextInfo];
        }
    }
}


- (NSString*)HTML{
    if (_text.length == 0) {
        return nil;
    }
    NSMutableString *returnValue = [NSMutableString string];
    NSIndexSet *rangeSet = [self rangeSet];
    NSUInteger currentIndex = [rangeSet firstIndex];
    while (1) {
        NSUInteger nextIndex = [rangeSet indexGreaterThanIndex:currentIndex];
        if (nextIndex == NSNotFound) {
            nextIndex = [_text length];
        }
        [returnValue appendFormat:@"<span id='%@TNode%lu'>", _idKey, currentIndex];
        NSString *originalText = [_text substringFromIndex:currentIndex toIndex:nextIndex];
        NSString *spaceText = [originalText stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        spaceText = [spaceText stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
        [returnValue appendString:spaceText];
        [returnValue appendString:@"</span>"];
        if (nextIndex == [_text length]) {
            break;
        }
        currentIndex = nextIndex;
    }
    return returnValue;
}

- (NSIndexSet *)rangeSet{
    NSMutableIndexSet *rangeSet = [[NSMutableIndexSet alloc] init];
    for (TextIndexInfo *info in _fontInfos) {
        [rangeSet addIndex:info.index];
    }
    for (NSNumber *size in _fontSizeInfoCollection) {
        NSMutableArray *infos = [_fontSizeInfoCollection objectForKey:size];
        for (TextIndexInfo *info in infos) {
            [rangeSet addIndex:info.index];
        }
    }
    return rangeSet;
}

- (NSIndexSet *)viewPortSet{
    NSMutableIndexSet *viewPortSet = [[NSMutableIndexSet alloc] init];
    for (NSNumber *size in _fontSizeInfoCollection) {
        [viewPortSet addIndex:[size integerValue]];
    }
    return viewPortSet;
}

     
- (NSDictionary*)css{
    //get all range to make span
    NSIndexSet *viewPortSet = [self viewPortSet];
    NSIndexSet *rangeSet = [self rangeSet];
    
    NSMutableDictionary *css = [NSMutableDictionary dictionary];
    [viewPortSet enumerateIndexesUsingBlock:^(NSUInteger viewPort, BOOL *stop) {
        NSMutableDictionary *cssIDDict = [NSMutableDictionary dictionary];
        [css setObject:cssIDDict forKey:@(viewPort)];
        NSMutableArray *fontSizeInfos = [_fontSizeInfoCollection objectForKey:@(viewPort)];
        [rangeSet enumerateIndexesUsingBlock:^(NSUInteger range, BOOL *stop) {
            NSMutableDictionary *cssDict = [NSMutableDictionary dictionary];
            [cssIDDict setObject:cssDict forKey:[NSString stringWithFormat:@"%@TNode%ld", _idKey, range]];
            NSNumber *size = [self infoObjectAtArray:fontSizeInfos beforeOrEqualIndex:range].info;
            [cssDict setObject:size forKey:IUCSSTagFontSize];
            if (viewPort == IUCSSMaxViewPortWidth) {
                NSString *fontName = [self infoObjectAtArray:_fontInfos beforeOrEqualIndex:range].info;
                [cssDict setObject:fontName forKey:IUCSSTagFontName];
            }
        }];
    }];
    
    
    return css;
}

- (void)removeMediaQuery:(NSInteger)viewPortWidth{
    assert(viewPortWidth != IUCSSMaxViewPortWidth);
    [_fontSizeInfoCollection removeObjectForKey:@(viewPortWidth)];
}


- (void)prepareTextFont:(NSString*)name{
    _preparedFontName = [name copy];
}

- (void)prepareTextFontSize:(NSUInteger)size{
    _preparedFontSize = size;
}

- (void)insertString:(NSString*)insertText atIndex:(NSUInteger)index{
    //index 보다 뒤에 있는 폰트 정보를 text length만큼 뒤로 밈
    //replace 와 다른 점은 prepare 된 정보를 이용한다는 것
    [self replaceText:insertText atRange:NSMakeRange(index, 0)];
    if (_preparedFontName) {
        [self setFont:_preparedFontName atRange:NSMakeRange(index, insertText.length)];
    }
    _cursorLocationInText = index + insertText.length;
}

- (void)replaceText:(NSString*)string atRange:(NSRange)range{
    NSRange modifiedRange = range;
    if (range.length != 0) {
        // 0일때는 지우지 않음
        if (modifiedRange.location == 0) {
            modifiedRange.location = 1;
            modifiedRange.length --;
        }
        [self deleteInfoArray:_fontInfos atRange:modifiedRange];
        [self moveInfoArray:_fontInfos from:modifiedRange.location distance:string.length - modifiedRange.length];
        [self removeDuplicatedInfo:_fontInfos];
        
        for (NSNumber *viewPort in _fontSizeInfoCollection) {
            NSMutableArray *fontSizes = [_fontSizeInfoCollection objectForKey:viewPort];
            [self deleteInfoArray:fontSizes atRange:modifiedRange];
            [self moveInfoArray:fontSizes from:modifiedRange.location distance:string.length - modifiedRange.length];
            [self removeDuplicatedInfo:fontSizes];
        }
    }
    [_text replaceCharactersInRange:range withString:string];
    _cursorLocationInText = range.location + string.length;
}


- (void)deleteTextInRange:(NSRange)range{
    assert(range.length != 0);
    NSRange modifiedRange = range;
    //css는 제일 앞 부분이 삭제 되지 않게 조정한다.
    if (modifiedRange.location == 0) {
        modifiedRange.location = 1;
        modifiedRange.length --;
        if (modifiedRange.length == 0) {
            _cursorLocationInText = range.location;
            [_text deleteCharactersInRange:range];
            return;
        }
    }
    [self deleteInfoArray:_fontInfos atRange:modifiedRange];
    [self removeDuplicatedInfo:_fontInfos];
    
    for (NSNumber *viewPort in _fontSizeInfoCollection) {
        NSMutableArray *fontSizes = [_fontSizeInfoCollection objectForKey:viewPort];
        [self deleteInfoArray:fontSizes atRange:modifiedRange];
        [self removeDuplicatedInfo:fontSizes];
    }
    
    //text 삭제
    //css 삭제보다 뒤로 둔다. assert 문 돌리기 위해서.
    [_text deleteCharactersInRange:range];
    _cursorLocationInText = range.location;
}

- (NSDictionary*)cursor{
    if ([_text length] == 0) {
        // no text
        return @{IUTextCursorLocationID: _idKey, IUTextCursorLocationIndex:@(0)};
    }
    NSIndexSet *indexSet = [self rangeSet];
    NSInteger indexOfSpan = [indexSet indexLessThanOrEqualToIndex:_cursorLocationInText];
//    NSInteger spanCount = [indexSet countOfIndexesInRange:NSMakeRange(0, indexOfSpan)];
    NSString *cursorLocation = [NSString stringWithFormat:@"%@TNode%ld", _idKey, indexOfSpan];

    return @{IUTextCursorLocationID: cursorLocation, IUTextCursorLocationIndex:@(_cursorLocationInText - indexOfSpan)};
}

- (NSDictionary*)fontInfoAtPoint:(NSUInteger)point{
    return [NSDictionary dictionary];
}


@end
