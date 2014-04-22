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

@implementation IUTextManager{
    NSMutableArray *fontInfos;
    NSMutableDictionary *fontSizeInfoCollection;
    NSMutableString *text;
    
    NSInteger preparedFontSize;
    NSString *preparedFontName;
    
    NSInteger _cursorLocationInText;
}

- (id)init{
    self = [super init];
    fontInfos = [NSMutableArray array];
    text = [NSMutableString string];
    fontSizeInfoCollection = [NSMutableDictionary dictionary];

    [self setValue:@"Helvatica" forRange:NSZeroRange inInfos:fontInfos];
    [fontSizeInfoCollection setObject:[NSMutableArray array] forKey:@(IUCSSDefaultCollection)];
    [self setValue:@(25) forRange:NSZeroRange inInfos:fontSizeInfoCollection[@(IUCSSDefaultCollection)]];
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
    if (text.length == 0) {
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
        if (range.location + range.length < [text length]) {
            TextIndexInfo *lastInfo = [self infoObjectAtArray:infos beforeIndex:range.location];
            if (lastInfo) {
                // media query의 경우 lastInfo가 없을 수도 있음.
                TextIndexInfo *newInfo = [[TextIndexInfo alloc] init];
                newInfo.info = lastInfo.info;
                newInfo.index = range.location + range.length;
                [infos addObject:newInfo];
            }
        }
        else if (range.location + range.length > [text length]){
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
    [self setValue:name forRange:range inInfos:fontInfos];
}

- (void)setFontSize:(NSInteger)size atRange:(NSRange)range{
    //만약 text가 있는 상태에서 range.location 이 zero면 잘못 들어온거
    if (range.length == 0 && [text length] > 0) {
        [NSException raise:@"RangeLength" format:@"Range Length is zero"];
    }
    NSMutableArray *fontSizeInfos = [fontSizeInfoCollection objectForKey:@(_editViewPortWidth)];
    if (fontSizeInfos == nil) {
        //디폴트를 카피해온다
        NSArray *defaultFontSizes = [fontSizeInfoCollection objectForKey:@(IUCSSDefaultCollection)];
        fontSizeInfos = [[NSMutableArray alloc] initWithArray:defaultFontSizes copyItems:YES];
        [fontSizeInfoCollection setObject:fontSizeInfos forKey:@(_editViewPortWidth)];
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
    [self sortInfoArray:fontInfos];
}


- (void)deleteInfoArray:(NSMutableArray*)array atRange:(NSRange)range{
    // string의 끝까지 지울 경우 : 그냥 범위안을 다 지운다.
    // string의 끝까지 지우지 않을 경우 + Range 밖 처음의 Info가 바로 따라 붙을 경우 : 범위안을 다 지운다.
    // string의 끝까지 지우지 않을 경우 + Range 밖 처음의 Info가 떨어져 있을경우 : 마지막 Info를 뒤로 밀어둔다.
    NSLog(text);
    assert(text.length >= range.location + range.length);

    NSArray *deleteArray = [self infoObjectsAtArray:array ofRange:range];
    TextIndexInfo *lastInfo = [deleteArray lastObject];
    [array removeObjectsInArray:deleteArray];
    
    if ([text length] > range.location + range.length ) {
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
    if (text.length == 0) {
        return nil;
    }
    NSMutableString *returnValue = [NSMutableString string];
    NSIndexSet *rangeSet = [self rangeSet];
    NSUInteger currentIndex = [rangeSet firstIndex];
    while (1) {
        NSUInteger nextIndex = [rangeSet indexGreaterThanIndex:currentIndex];
        if (nextIndex == NSNotFound) {
            nextIndex = [text length];
        }
        [returnValue appendFormat:@"<span id='%@TNode%lu'>", _idKey, currentIndex];
        [returnValue appendString:[text substringFromIndex:currentIndex toIndex:nextIndex]];
        [returnValue appendString:@"</span>"];
        if (nextIndex == [text length]) {
            break;
        }
        currentIndex = nextIndex;
    }
    return returnValue;
}

- (NSIndexSet *)rangeSet{
    NSMutableIndexSet *rangeSet = [[NSMutableIndexSet alloc] init];
    for (TextIndexInfo *info in fontInfos) {
        [rangeSet addIndex:info.index];
    }
    for (NSNumber *size in fontSizeInfoCollection) {
        NSMutableArray *infos = [fontSizeInfoCollection objectForKey:size];
        for (TextIndexInfo *info in infos) {
            [rangeSet addIndex:info.index];
        }
    }
    return rangeSet;
}

- (NSIndexSet *)viewPortSet{
    NSMutableIndexSet *viewPortSet = [[NSMutableIndexSet alloc] init];
    for (NSNumber *size in fontSizeInfoCollection) {
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
        NSMutableArray *fontSizeInfos = [fontSizeInfoCollection objectForKey:@(viewPort)];
        [rangeSet enumerateIndexesUsingBlock:^(NSUInteger range, BOOL *stop) {
            NSMutableDictionary *cssDict = [NSMutableDictionary dictionary];
            [cssIDDict setObject:cssDict forKey:[NSString stringWithFormat:@"%@TNode%ld", _idKey, range]];
            NSNumber *size = [self infoObjectAtArray:fontSizeInfos beforeOrEqualIndex:range].info;
            [cssDict setObject:size forKey:IUCSSTagFontSize];
            if (viewPort == IUCSSDefaultCollection) {
                NSString *fontName = [self infoObjectAtArray:fontInfos beforeOrEqualIndex:range].info;
                [cssDict setObject:fontName forKey:IUCSSTagFontName];
            }
        }];
    }];
    
    
    return css;
}

- (void)removeMediaQuery:(NSInteger)viewPortWidth{
    assert(viewPortWidth != IUCSSDefaultCollection);
    [fontSizeInfoCollection removeObjectForKey:@(viewPortWidth)];
}


- (void)prepareTextFont:(NSString*)name{
    preparedFontName = [name copy];
}

- (void)prepareTextFontSize:(NSUInteger)size{
    preparedFontSize = size;
}

- (void)insertString:(NSString*)insertText atIndex:(NSUInteger)index{
    //index 보다 뒤에 있는 폰트 정보를 text length만큼 뒤로 밈
    //replace 와 다른 점은 prepare 된 정보를 이용한다는 것
    [self replaceText:insertText atRange:NSMakeRange(index, 0)];
    if (preparedFontName) {
        [self setFont:preparedFontName atRange:NSMakeRange(index, insertText.length)];
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
        [self deleteInfoArray:fontInfos atRange:modifiedRange];
        [self moveInfoArray:fontInfos from:modifiedRange.location distance:string.length - modifiedRange.length];
        [self removeDuplicatedInfo:fontInfos];
        
        for (NSNumber *viewPort in fontSizeInfoCollection) {
            NSMutableArray *fontSizes = [fontSizeInfoCollection objectForKey:viewPort];
            [self deleteInfoArray:fontSizes atRange:modifiedRange];
            [self moveInfoArray:fontSizes from:modifiedRange.location distance:string.length - modifiedRange.length];
            [self removeDuplicatedInfo:fontSizes];
        }
    }
    [text replaceCharactersInRange:range withString:string];
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
            [text deleteCharactersInRange:range];
            return;
        }
    }
    [self deleteInfoArray:fontInfos atRange:modifiedRange];
    [self removeDuplicatedInfo:fontInfos];
    
    for (NSNumber *viewPort in fontSizeInfoCollection) {
        NSMutableArray *fontSizes = [fontSizeInfoCollection objectForKey:viewPort];
        [self deleteInfoArray:fontSizes atRange:modifiedRange];
        [self removeDuplicatedInfo:fontSizes];
    }
    
    //text 삭제
    //css 삭제보다 뒤로 둔다. assert 문 돌리기 위해서.
    [text deleteCharactersInRange:range];
    _cursorLocationInText = range.location;
}

- (NSDictionary*)cursor{
    if ([text length] == 0) {
        // no text
        return @{IUTextCursorLocationID: _idKey, IUTextCursorLocationIndex:@(0)};
    }
    NSIndexSet *indexSet = [self rangeSet];
    NSInteger indexOfSpan = [indexSet indexLessThanOrEqualToIndex:_cursorLocationInText];
//    NSInteger spanCount = [indexSet countOfIndexesInRange:NSMakeRange(0, indexOfSpan)];
    NSString *cursorLocation = [NSString stringWithFormat:@"%@TNode%ld", _idKey, indexOfSpan];

    return @{IUTextCursorLocationID: cursorLocation, IUTextCursorLocationIndex:@(_cursorLocationInText - indexOfSpan)};
}


@end
