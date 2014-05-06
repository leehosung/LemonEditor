//
//  IUBox.m
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUIdentifierManager.h"

#import "IUBox.h"
#import "NSObject+JDExtension.h"
#import "NSCoder+JDExtension.h"
#import "IUCompiler.h"
#import "IUDocument.h"
#import "IUBox.h"
#import "IUTextManager.h"

@interface IUBox()
@property NSMutableArray *m_children;
@end

@implementation IUBox{
    int delegateEnableLevel;
    NSMutableSet *changedCSSWidths;
    IUTextManager *textManager;
    NSPoint originalPoint;
    NSSize originalSize;
    NSSize originalPercentSize;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUBox class] propertiesWithOutProperties:@[@"delegate"]]];
        _css = [aDecoder decodeObjectForKey:@"css"];
        _css.delegate = self;
        
        _event = [aDecoder decodeObjectForKey:@"event"];
        
        _m_children=[aDecoder decodeObjectForKey:@"children"];
        delegateEnableLevel = 1;
        [self addObserver:self forKeyPath:@"delegate.selectedFrameWidth" options:0 context:nil];
        [self addObserver:self forKeyPath:@"delegate.maxFrameWidth" options:0 context:nil];
        changedCSSWidths = [NSMutableSet set];
        for (IUBox *iu in self.children) {
            [iu bind:@"identifierManager" toObject:self withKeyPath:@"identifierManager" options:nil];
        }
        textManager = [aDecoder decodeObjectForKey:@"textManager"];
        [textManager bind:@"idKey" toObject:self withKeyPath:@"htmlID" options:nil];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if ([self.htmlID length] == 0) {
        assert(0);
    }
    [aCoder encodeFromObject:self withProperties:[[IUBox class] propertiesWithOutProperties:@[@"identifierManager"]]];
    [aCoder encodeObject:self.css forKey:@"css"];
    [aCoder encodeObject:self.event forKey:@"event"];
    [aCoder encodeObject:textManager forKey:@"textManager"];
    [aCoder encodeObject:_m_children forKey:@"children"];
}

-(id)initWithManager:(IUIdentifierManager*)manager option:(NSDictionary *)option{
    self = [super init];{
        _css = [[IUCSS alloc] init];
        _css.delegate = self;
        _identifierManager = manager;
        _event = [[IUEvent alloc] init];
        textManager = [[IUTextManager alloc] init];
        [textManager bind:@"idKey" toObject:self withKeyPath:@"htmlID" options:nil];
        
        //NO - Pixel
        [_css setValue:@(0) forTag:IUCSSTagXUnit forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagYUnit forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagWidthUnit forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagHeightUnit forWidth:IUCSSMaxViewPortWidth];
        
        if (self.hasWidth) {
            [_css setValue:@(50+rand()%300) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        }
        if (self.hasHeight) {
            [_css setValue:@(35) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        }
        
        //background
        [_css setValue:[NSColor randomColor] forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(IUBGSizeTypeAuto) forTag:IUCSSTagBGSize forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBGXPosition forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBGYPosition forWidth:IUCSSMaxViewPortWidth];
        
        //border
        [_css setValue:@(0) forTag:IUCSSTagBorderTopWidth forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBorderLeftWidth forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBorderRightWidth forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(0) forTag:IUCSSTagBorderBottomWidth forWidth:IUCSSMaxViewPortWidth];
        
        [_css setValue:@"NO" forTag:IUCSSTagBGGradient forWidth:IUCSSMaxViewPortWidth];
        
        [_css setValue:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderTopColor forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderLeftColor forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderRightColor forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderBottomColor forWidth:IUCSSMaxViewPortWidth];

        //type
        [_css setValue:@"Arial" forTag:IUCSSTagFontName forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(12) forTag:IUCSSTagFontSize forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@"Auto" forTag:IUCSSTagLineHeight forWidth:IUCSSMaxViewPortWidth];
        [_css setValue:@(IUTextAlignCenter) forTag:IUCSSTagTextAlign forWidth:IUCSSMaxViewPortWidth];


        delegateEnableLevel = 1;
        
        _m_children = [NSMutableArray array];
        
        [self addObserver:self forKeyPath:@"delegate.maxFrameWidth" options:0 context:nil];
        [self addObserver:self forKeyPath:@"delegate.selectedFrameWidth" options:0 context:nil];

        changedCSSWidths = [NSMutableSet set];
    }
    return self;
}


-(id)init{
    assert(0);
    return nil;
}

- (void)delegate_selectedFrameWidthDidChange:(NSDictionary*)change{
    if (self.delegate) {
        if (self.delegate.maxFrameWidth == self.delegate.selectedFrameWidth) {
            [_css setEditWidth:IUCSSMaxViewPortWidth];
        }
        else {
            [_css setEditWidth:self.delegate.selectedFrameWidth];
        }
    }
}

-(NSMutableArray*)allChildren{
    if (self.children) {
        NSMutableArray *array = [NSMutableArray array];
        for (IUBox *iu in self.children) {
            [array addObject:iu];
            [array addObjectsFromArray:iu.allChildren];
        }
        return array;
    }
    return nil;
}



-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width{
    return [_css tagDictionaryForWidth:(int)width];
}

//source
-(NSString*)html{
    return [self.document.compiler editorHTML:self];
}

-(NSString*)cssForWidth:(NSInteger)width isHover:(BOOL)isHover{
    return [self.document.compiler CSSContentFromAttributes:[self CSSAttributesForWidth:width] ofClass:self isHover:isHover];
}

-(void)CSSUpdated:(NSDictionary*)tagDictionary forWidth:(NSInteger)width isHover:(BOOL)isHover{
    if (delegateEnableLevel == 1) {
        NSString *css = [self cssForWidth:width isHover:isHover];
        if (isHover) {
            [self.delegate IU:[self.htmlID hoverIdentifier] CSSUpdated:css forWidth:width];
        }
        else {
            [self.delegate IU:self.htmlID CSSUpdated:css forWidth:width];
        }
    }
    else {
        [changedCSSWidths addObject:@(width)];
    }
}



-(void)enableDelegate:(id)sender{
    delegateEnableLevel ++;
}

-(void)disableDelegate:(id)sender{
    delegateEnableLevel --;
}

//delegation
-(BOOL)CSSShouldChangeValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width{
    return YES;
}

-(void)setHtmlID:(NSString *)htmlID{
    if (self.name == nil || [self.name isEqualToString:_htmlID]) {
        _htmlID = [htmlID copy];
        [self willChangeValueForKey:@"name"];
        _name = [htmlID copy];
        [self didChangeValueForKey:@"name"];
    }
    else{
        _htmlID = [htmlID copy];
    }
}

-(BOOL)shouldAddIU{
    return YES;
}

-(BOOL)addIU:(IUBox *)iu error:(NSError**)error{
    
    assert(iu != self);
    
    if([self shouldAddIU]){
        [_m_children addObject:iu];
        if (iu.delegate == nil) {
            iu.delegate = self.delegate;
        }
        iu.parent = self;
        [self.delegate IU:iu.htmlID HTML:iu.html withParentID:self.htmlID];
        [self.delegate IU:iu.htmlID CSSUpdated:[iu cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
        for (IUBox *child in iu.children) {
            [self.delegate IU:child.htmlID CSSUpdated:[child cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
        }
        [_identifierManager addIU:iu];
        [iu bind:@"identifierManager" toObject:self withKeyPath:@"identifierManager" options:nil];
        return YES;
    }
    return NO;
}

-(BOOL)addIUReference:(IUBox *)iu error:(NSError**)error{
    [_m_children addObject:iu];
    if (self.delegate) {
        iu.delegate = self.delegate;
    }
    return YES;
}

- (BOOL)shouldRemoveIU{
    return YES;
}

-(BOOL)removeIU:(IUBox *)iu{
    if([iu shouldRemoveIU]){
        [_m_children removeObject:iu];
        [self.delegate IURemoved:iu.htmlID];
        return YES;
    }
    return NO;
}

-(BOOL)changeIUIndex:(IUBox*)iu to:(NSUInteger)index error:(NSError**)error{
    //자기보다 앞으로 갈 경우
    NSInteger currentIndex = [_m_children indexOfObject:iu];
    [_m_children removeObject:iu];
    if (index > currentIndex) {
        index --;
    }
    [_m_children insertObject:iu atIndex:index];
    return YES;
}

-(BOOL)removeIUAtIndex:(NSUInteger)index{
    IUBox *box = [_m_children objectAtIndex:index];
    return [self removeIU:box];
}


-(BOOL)insertIU:(IUBox *)iu atIndex:(NSInteger)index  error:(NSError**)error{
    if([self shouldAddIU]){
        [_m_children insertObject:iu atIndex:index];
        return YES;
    }
    return NO;
}

-(NSArray*)children{
    return [_m_children copy];
}

-(void)setDelegate:(id<IUSourceDelegate>)delegate{
    _delegate = delegate;
    for (IUBox *obj in _m_children) {
        obj.delegate = delegate;
    }
}

-(IUDocument*)document{
    if ([self isKindOfClass:[IUDocument class]]) {
        return (IUDocument*)self;
    }
    if (self.parent) {
        return self.parent.document;
    }
    return nil;
}

-(NSString*)description{
    return [[super description] stringByAppendingFormat:@" %@", self.htmlID];
}


- (void)setPosition:(NSPoint)position{
    [_css setValue:@(position.x) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagX]];
    [_css setValue:@(position.y) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagY]];
}

- (void)setPercentFrame:(NSRect)frame{
    CGFloat x = frame.origin.x;
    CGFloat xExist =[[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentX] floatValue];
    if (x != xExist) {
        [_css setValue:@(frame.origin.x) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentX]];
    }
    if (frame.origin.x != [[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentY] floatValue]) {
        [_css setValue:@(frame.origin.y) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentY]];
    }
    if (frame.origin.x != [[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentHeight] floatValue]) {
        [_css setValue:@(frame.size.height) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentHeight]];
    }
    if (frame.origin.x != [[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentWidth] floatValue]) {
        [_css setValue:@(frame.size.width) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentWidth]];
    }
}

- (void)setPixelFrame:(NSRect)frame{
    [_css setValue:@(frame.origin.x) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagX]];
    [_css setValue:@(frame.origin.y) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagY]];
    [_css setValue:@(frame.size.height) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagHeight]];
    [_css setValue:@(frame.size.width) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagWidth]];
    
}

-(BOOL)percentUnitAtCSSTag:(IUCSSTag)tag{
    BOOL unit = [[_css valueForKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:tag]] boolValue];
    return unit;
}

- (void)movePosition:(NSPoint)point withParentSize:(NSSize)parentSize{
    
    //Set Pixel
    if([self hasX] && [self enableXUserInput]){
        NSInteger currentX = originalPoint.x + point.x;
        
        [_css setValue:@(currentX) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagX]];
        //set Percent if enablePercent
        BOOL enablePercentX = [self percentUnitAtCSSTag:IUCSSTagXUnit];
        if(enablePercentX){
            CGFloat percentX = 0;
            if(parentSize.width!=0){
                percentX = (currentX / parentSize.width) * 100;
            }
            [_css setValue:@(percentX) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentX]];
            
        }
    }
    
    if([self hasY] && [self enableYUserInput]){
        
        NSInteger currentY = originalPoint.y + point.y;
        [_css setValue:@(currentY) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagY]];
        
        
        BOOL enablePercentY = [self percentUnitAtCSSTag:IUCSSTagYUnit];
        if(enablePercentY){
            CGFloat percentY = 0;
            if(parentSize.height!=0){
                percentY = (currentY / parentSize.height) * 100;
            }
            [_css setValue:@(percentY) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentY]];
        }
    }
    
}

- (void)updateCSSForEditViewPort{
    [self.delegate IU:_htmlID CSSUpdated:[self cssForWidth:_css.editWidth isHover:NO] forWidth:_css.editWidth];
    [self.delegate IU:[_htmlID hoverIdentifier] CSSUpdated:[self cssForWidth:_css.editWidth isHover:YES] forWidth:_css.editWidth];
}

/* 
 drag 중간의 diff size로 하면 css에 의한 오차가 생김.
 drag session이 시작될때부터 위치에서의 diff size로 계산해야 오차가 발생 안함.
 drag session이 시작할때 그 때의 위치를 저장함.
 */
- (void)startDragSession{
    NSInteger currentWidth = [_css.assembledTagDictionary[IUCSSTagWidth] integerValue];
    NSInteger currentHeight = [_css.assembledTagDictionary[IUCSSTagHeight] integerValue];

    originalSize = NSMakeSize(currentWidth, currentHeight);
    
    NSInteger currentPWidth = [_css.assembledTagDictionary[IUCSSTagPercentWidth] floatValue];
    NSInteger currentPHeight = [_css.assembledTagDictionary[IUCSSTagPercentHeight] floatValue];

    originalPercentSize = NSMakeSize(currentPWidth, currentPHeight);

    NSInteger currentX = [_css.assembledTagDictionary[IUCSSTagX] integerValue];
    NSInteger currentY = 0;
    NSPoint distancePoint = [self.delegate distanceFromIU:self.htmlID to:self.parent.htmlID];

    if([_css.assembledTagDictionary objectForKey:IUCSSTagY]){
        currentY = [_css.assembledTagDictionary[IUCSSTagY] integerValue];
    }
    else if(self.flow == NO){
        currentY = distancePoint.y;
    }
    originalPoint = NSMakePoint(currentX, currentY);
}

- (void)increaseSize:(NSSize)size withParentSize:(NSSize)parentSize{
    if([self hasWidth] && [self enableWidthUserInput]){
        NSInteger currentWidth = originalSize.width;
        currentWidth += size.width;
        [_css setValue:@(currentWidth) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagWidth]];
        
        CGFloat percentWidth = originalPercentSize.width;
        if(parentSize.width!=0){
            percentWidth += (size.width / parentSize.width) *100;
        }
        [_css setValue:@(percentWidth) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentWidth]];
        
     
    }
    if([self hasHeight] && [self enableHeightUserInput]){
        NSInteger currentHeight = originalSize.height;
        currentHeight += size.height;
        [_css setValue:@(currentHeight) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagHeight]];
        
        CGFloat percentHeight = originalPercentSize.height;
        if(parentSize.height!=0){
            percentHeight += (size.height / parentSize.height) *100;
        }
        [_css setValue:@(percentHeight) forKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagPercentHeight]];
        
    }
}

- (void)insertImage:(NSString *)imageName{
    NSDictionary *defaultTagDictionary = [_css tagDictionaryForWidth:IUCSSMaxViewPortWidth];
    if (defaultTagDictionary) {
        [_css setValue:imageName forTag:IUCSSTagImage forWidth:_css.editWidth];
    }
    [_css setValue:imageName forTag:IUCSSTagImage forWidth:IUCSSMaxViewPortWidth];
}

-(BOOL)hasX{
    return YES;
}
-(BOOL)hasY{
    return YES;
}
-(BOOL)hasWidth{
    return YES;
}
-(BOOL)hasHeight{
    return YES;
}


-(void)startGrouping{
    delegateEnableLevel --;
}

-(void)endGrouping{
    delegateEnableLevel ++;
    for (NSNumber *number in changedCSSWidths) {
        [self.delegate IU:self.htmlID CSSUpdated:[self cssForWidth:[number intValue] isHover:NO] forWidth:[number intValue]];
        [self.delegate IU:[self.htmlID hoverIdentifier] CSSUpdated:[self cssForWidth:[number intValue] isHover:YES] forWidth:[number intValue]];
    }
}

-(void)setLink:(NSString *)link{
    _link = link;
//    [self.delegate IU:self.htmlID setLink:link];
}
-(void)setDivLink:(NSString *)divLink{
    _divLink = divLink;
}

-(void)dealloc{
    [_identifierManager removeIdentifier:self.htmlID];
    [self removeObserver:self forKeyPath:@"delegate.maxFrameWidth"];
    [self removeObserver:self forKeyPath:@"delegate.selectedFrameWidth"];

}

-(BOOL)shouldEditText{
    return YES;
}

- (void)replaceText:(NSString*)text withRange:(NSRange)range{
    [textManager replaceText:text atRange:range];
    
    NSUInteger index = [[self cursor][IUTextCursorLocationIndex] integerValue];
    NSString   *nID =[self cursor][IUTextCursorLocationID];
    
    [self.delegate IU:self.htmlID textHTML:self.html withParentID:self.parent.htmlID nearestID:nID index:index];
    
    NSMutableDictionary *cssDict = [textManager.css mutableCopy];
    NSDictionary *defaultCSS = cssDict[@(IUCSSMaxViewPortWidth)];
    for (NSString *identifier in defaultCSS) {
        NSString *src = [self.document.compiler fontCSSContentFromAttributes:defaultCSS[identifier]];
        [self.delegate IU:identifier CSSUpdated:src forWidth:IUCSSMaxViewPortWidth];
    }
}

- (void)insertText:(NSString*)text withRange:(NSRange)range{
    NSLog(@"insertText %@ (%ld, %ld)", text, range.location, range.length);

    [textManager replaceText:text atRange:range];
    NSUInteger index = [[self cursor][IUTextCursorLocationIndex] integerValue];
    NSString   *nID =[self cursor][IUTextCursorLocationID];
    
    [self.delegate IU:self.htmlID textHTML:self.html withParentID:self.parent.htmlID nearestID:nID index:index];
}


- (void)deleteTextInRange:(NSRange)range{
    [textManager deleteTextInRange:range];
    NSUInteger index = [[self cursor][IUTextCursorLocationIndex] integerValue];
    NSString   *nID =[self cursor][IUTextCursorLocationID];
    
    [self.delegate IU:self.htmlID textHTML:self.html withParentID:self.parent.htmlID nearestID:nID index:index];
}


- (NSString*)textHTML{
    return textManager.HTML;
}

- (NSDictionary*)cursor{
    return [textManager cursor];
}

- (BOOL)flowChangeable{
    return YES;
}

- (BOOL)floatRightChangeable{
    return YES;
}

- (void)setFloatRight:(BOOL)floatRight{
    _floatRight = floatRight;
    if (floatRight) {
        if (self.flow == NO) {
            self.flow = YES;
        }
        [self.css eradicateTag:IUCSSTagX];
        [self.css eradicateTag:IUCSSTagY];
    }
    
    [self.delegate IU:self.htmlID CSSUpdated:[self cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
}

- (void)setFlow:(BOOL)flow{
    _flow = flow;
    [self.css eradicateTag:IUCSSTagX];
    [self.css eradicateTag:IUCSSTagY];
    
    [self.delegate IU:self.htmlID CSSUpdated:[self cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
}

//iucontroller & inspectorVC sync가 안맞는듯.
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}


#pragma mark -
#pragma mark user input

- (BOOL)enableXUserInput{
    return YES;
}
- (BOOL)enableYUserInput{
    return YES;
}
- (BOOL)enableWidthUserInput{
    return YES;
}
- (BOOL)enableHeightUserInput{
    return YES;
}


@end