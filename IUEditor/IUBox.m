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
#import "IUSheet.h"
#import "IUBox.h"
#import "IUClass.h"
#import "IUProject.h"

@interface IUBox()
@end

@implementation IUBox{
    int delegateEnableLevel;
    NSMutableSet *changedCSSWidths;
    NSPoint originalPoint;
    NSSize originalSize;
    NSSize originalPercentSize;
    IUProject *_tempProject;
}


/* Note
 IUText is not programmed.
 */

- (id)copyWithZone:(NSZone *)zone{
    IUBox *box = [[[self class] allocWithZone: zone] init];
    IUCSS *newCSS = [_css copy];
    IUEvent *newEvent = [_event copy];
    NSArray *children = [self.children deepCopy];
    //FIXME: connect textmanager
    box.css = newCSS;
    newCSS.delegate  = box;
    box.event = newEvent;
    for (IUBox *iu in children) {
        assert([box addIU:iu error:nil]);
    }
    box.delegate = self.delegate;
    [box setTempProject:self.project];
    
    assert(self.project);
    [self.project.identifierManager resetUnconfirmedIUs];
    [self.project.identifierManager setNewIdentifierAndRegisterToTemp:box withKey:@"copy"];
    box.name = box.htmlID;
    [box.project.identifierManager confirm];

    return box;
}

- (void)setTempProject:(IUProject*)project{
    _tempProject = project;
}

- (void)setCss:(IUCSS *)css{
    _css = css;
}

- (void)setEvent:(IUEvent *)event{
    _event = event;
}


- (void)fetch{
    assert(_css);
    assert(_event);
    delegateEnableLevel = 1;
    [self addObserver:self forKeyPath:@"delegate.selectedFrameWidth" options:0 context:nil];
    [self addObserver:self forKeyPath:@"delegate.maxFrameWidth" options:0 context:nil];
    changedCSSWidths = [NSMutableSet set];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUBox class] propertiesWithOutProperties:@[@"delegate"]]];
        _css = [aDecoder decodeObjectForKey:@"css"];
        _css.delegate = self;
        
        _event = [aDecoder decodeObjectForKey:@"event"];
        
        _m_children=[aDecoder decodeObjectForKey:@"children"];
        [self fetch];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if ([self.htmlID length] == 0) {
        assert(0);
    }
    [aCoder encodeFromObject:self withProperties:[[IUBox class] propertiesWithOutProperties:@[@"identifierManager", @"textController"]]];
    [aCoder encodeObject:self.css forKey:@"css"];
    [aCoder encodeObject:self.event forKey:@"event"];
    [aCoder encodeObject:_m_children forKey:@"children"];
}


-(id)initWithProject:(IUProject*)project options:(NSDictionary*)options{
    self = [super init];
    _tempProject = project;
    _css = [[IUCSS alloc] init];
    _css.delegate = self;
    _event = [[IUEvent alloc] init];
    _m_children = [NSMutableArray array];

    
    
    [_css setValue:@(0) forTag:IUCSSTagXUnit forWidth:IUCSSMaxViewPortWidth];
    [_css setValue:@(0) forTag:IUCSSTagYUnit forWidth:IUCSSMaxViewPortWidth];
    [_css setValue:@(0) forTag:IUCSSTagWidthUnit forWidth:IUCSSMaxViewPortWidth];
    [_css setValue:@(0) forTag:IUCSSTagHeightUnit forWidth:IUCSSMaxViewPortWidth];
    
    if (self.hasWidth) {
        [_css setValue:@(50+rand()%50) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
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
    
    [_css setValue:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderTopColor forWidth:IUCSSMaxViewPortWidth];
    [_css setValue:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderLeftColor forWidth:IUCSSMaxViewPortWidth];
    [_css setValue:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderRightColor forWidth:IUCSSMaxViewPortWidth];
    [_css setValue:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1] forTag:IUCSSTagBorderBottomColor forWidth:IUCSSMaxViewPortWidth];
    
    //type
    [_css setValue:@"Arial" forTag:IUCSSTagFontName forWidth:IUCSSMaxViewPortWidth];
    [_css setValue:@(12) forTag:IUCSSTagFontSize forWidth:IUCSSMaxViewPortWidth];
    [_css setValue:@"Auto" forTag:IUCSSTagLineHeight forWidth:IUCSSMaxViewPortWidth];
    [_css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign forWidth:IUCSSMaxViewPortWidth];

    
    [self fetch];
    assert(project);
    assert(project.identifierManager);
    [project.identifierManager setNewIdentifierAndRegisterToTemp:self withKey:nil];
    self.name = self.htmlID;
    return self;
}


-(id)init{
    //only called from copyWithZone
    self = [super init];
    if (self) {
        _css = [[IUCSS alloc] init];
        _css.delegate = self;
        _event = [[IUEvent alloc] init];
        _m_children = [NSMutableArray array];

        [self fetch];
    }
    return self;
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
    return [self.project.compiler editorHTML:self].string;
}

-(NSString*)cssForWidth:(NSInteger)width isHover:(BOOL)isHover{
    BOOL isDefaultWidth = (width == IUCSSMaxViewPortWidth) ? YES : NO;
    return [self.project.compiler CSSContentFromAttributes:[self CSSAttributesForWidth:width] ofClass:self isHover:isHover isDefaultWidth:isDefaultWidth];
}

-(void)CSSUpdated:(NSDictionary*)tagDictionary forWidth:(NSInteger)width isHover:(BOOL)isHover{
    if (delegateEnableLevel == 1) {
        NSString *css = [self cssForWidth:width isHover:isHover];

        if (isHover) {
            [self.delegate IUClassIdentifier:[self.cssID hoverIdentifier] CSSUpdated:css forWidth:width];
        }
        else {
            [self.delegate IUClassIdentifier:self.cssID CSSUpdated:css forWidth:width];
        }
    }
    else {
        [changedCSSWidths addObject:@(width)];
    }
}

- (NSString *)cssID{
    return [NSString stringWithFormat:@".%@", self.htmlID];
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

-(BOOL)shouldAddIUByUserInput{
    return YES;
}

-(BOOL)addIU:(IUBox *)iu error:(NSError**)error{
    assert(iu != self);
    
    NSInteger index = [_m_children count];
    return [self insertIU:iu atIndex:index error:error];
}


-(BOOL)insertIU:(IUBox *)iu atIndex:(NSInteger)index  error:(NSError**)error{
    
    assert(iu != self);
    
    [_m_children insertObject:iu atIndex:index];
    
    //iu 의 delegate와 children
    if (iu.delegate == nil) {
        iu.delegate = self.delegate;
    }
    iu.parent = self;
    
    if ([self.sheet isKindOfClass:[IUClass class]]) {
        for (IUBox *import in [(IUClass*)self.sheet referenceImports]) {
            NSString *self_htmlID = [import.htmlID stringByAppendingFormat:@"__%@", self.htmlID];
            NSString *iu_htmlid = [import.htmlID stringByAppendingFormat:@"__%@", iu.htmlID];
            NSString *originalHTML = iu.html;
            NSString *replacedHTML = [originalHTML stringByReplacingOccurrencesOfString:@" id=" withString:[NSString stringWithFormat:@" id=%@__", import.htmlID]];
            [self.delegate IUHTMLIdentifier:iu_htmlid HTML:replacedHTML withParentID:self_htmlID];
        }
    }
    
    [self.delegate IUHTMLIdentifier:iu.htmlID HTML:iu.html withParentID:self.htmlID];
    [self.delegate IUClassIdentifier:iu.cssID CSSUpdated:[iu cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
    for (IUBox *child in iu.children) {
        [self.delegate IUClassIdentifier:child.cssID CSSUpdated:[child cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
    }
    [iu bind:@"identifierManager" toObject:self withKeyPath:@"identifierManager" options:nil];
    
    return YES;
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
- (BOOL)shouldRemoveIUByUserInput{
    return YES;
}

-(BOOL)removeIU:(IUBox *)iu{
    if([iu shouldRemoveIU]){
        //IURemoved 호출한 다음에 m_children을 호출해야함.
        //border를 지울려면 controller 에 iu 정보 필요. 
        [self.project.identifierManager unregisterIUs:@[iu]];
        [self.delegate IURemoved:iu.htmlID withParentID:iu.parent.htmlID];
        [_m_children removeObject:iu];
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
    
    [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.parent.htmlID];

    return YES;
}

-(BOOL)removeIUAtIndex:(NSUInteger)index{
    IUBox *box = [_m_children objectAtIndex:index];
    return [self removeIU:box];
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

-(IUSheet*)sheet{
    if ([self isKindOfClass:[IUSheet class]]) {
        return (IUSheet*)self;
    }
    if (self.parent) {
        return self.parent.sheet;
    }
    return nil;
}

- (IUProject *)project{
    if (self.sheet.group.project) {
        return self.sheet.group.project;
    }
    else if (_tempProject) {
        //not assigned to document
        return _tempProject;
    }
    assert(0);
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

#pragma mark move by drag & drop

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
    [self.delegate IUClassIdentifier:self.cssID CSSUpdated:[self cssForWidth:_css.editWidth isHover:NO] forWidth:_css.editWidth];
    [self.delegate IUClassIdentifier:[self.cssID hoverIdentifier] CSSUpdated:[self cssForWidth:_css.editWidth isHover:YES] forWidth:_css.editWidth];
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

- (BOOL)hasText{
    return NO;
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
        [self.delegate IUClassIdentifier:self.cssID CSSUpdated:[self cssForWidth:[number intValue] isHover:NO] forWidth:[number intValue]];
        [self.delegate IUClassIdentifier:[self.cssID hoverIdentifier] CSSUpdated:[self cssForWidth:[number intValue] isHover:YES] forWidth:[number intValue]];
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
    [self removeObserver:self forKeyPath:@"delegate.maxFrameWidth"];
    [self removeObserver:self forKeyPath:@"delegate.selectedFrameWidth"];

}

#pragma mark -

- (BOOL)flowChangeable{
    return YES;
}

- (BOOL)floatRightChangeable{
    return YES;
}

- (BOOL)overflowChangeable{
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
    if (self.delegate) {
        [self.delegate IUClassIdentifier:self.cssID CSSUpdated:[self cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
    }
}

- (void)setOverflow:(BOOL)overflow{
    _overflow = overflow;
    if (self.delegate) {
        [self.delegate IUClassIdentifier:self.cssID CSSUpdated:[self cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
    }
}

- (BOOL)centerChangeable{
    return YES;
}

- (void)setCenter:(BOOL)center{
    _center = center;
    if (center) {
        [self.css eradicateTag:IUCSSTagX];
    }
    if (self.delegate) {
        [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.parent.htmlID];
    }
}


- (void)setFlow:(BOOL)flow{
    _flow = flow;
    [self.css eradicateTag:IUCSSTagX];
    [self.css eradicateTag:IUCSSTagY];
    if (self.delegate) {
        [self.delegate IUClassIdentifier:self.cssID CSSUpdated:[self cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
        //중간에 set된 flow가 있으면 제대로 맞추기 위해서 html reload
        if(_flow){
            [self.delegate IUHTMLIdentifier:self.parent.htmlID HTML:self.parent.html withParentID:self.parent.parent.htmlID];
        }
    }
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


- (void)confirm{
    assert(self.project.identifierManager);
    [self.project.identifierManager confirm];
}

- (NSArray *)helpDictionary{
    return nil;
}

@end