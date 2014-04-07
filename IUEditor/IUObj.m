//
//  IUObj.m
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUObj.h"
#import "NSObject+JDExtension.h"
#import "NSCoder+JDExtension.h"
#import "IUCompiler.h"
#import "IUDocument.h"
#import "IUObj.h"

@interface IUObj()
@property NSMutableArray *m_children;
@end

@implementation IUObj{
    int delegateEnableLevel;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUObj class] propertiesWithOutProperties:@[@"delegate"]]];
        _css = [aDecoder decodeObjectForKey:@"css"];
        _css.delegate = self;
        _m_children=[aDecoder decodeObjectForKey:@"children"];
        delegateEnableLevel = 1;
        [self addObserver:self forKeyPath:@"delegate.selectedFrameWidth" options:0 context:nil];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if ([self.htmlID length] == 0) {
        assert(0);
    }
    [aCoder encodeFromObject:self withProperties:[[IUObj class] properties]];
    [aCoder encodeObject:self.css forKey:@"css"];
    [aCoder encodeObject:_m_children forKey:@"children"];
}

-(id)initWithSetting:(NSDictionary*)setting{
    self = [super init];{
        _css = [[IUCSS alloc] init];
        _css.delegate = self;
        
        [_css setValue:@(50+rand()%300) forTag:IUCSSTagWidth forWidth:IUCSSDefaultCollection];
        [_css setValue:@(35) forTag:IUCSSTagHeight forWidth:IUCSSDefaultCollection];
        [_css setValue:[NSColor randomColor] forTag:IUCSSTagBGColor forWidth:IUCSSDefaultCollection];
        delegateEnableLevel = 1;
        
        _m_children = [NSMutableArray array];
        
        [self addObserver:self forKeyPath:@"delegate.selectedFrameWidth" options:0 context:nil];
    }
    return self;
}


-(id)init{
    assert(0);
    return nil;
}

- (void)delegate_selectedFrameWidthDidChange:(NSDictionary*)change{
    if (self.delegate) {
        [_css setEditWidth:self.delegate.selectedFrameWidth];
    }
}

-(NSMutableArray*)allChildren{
    if (self.children) {
        NSMutableArray *array = [NSMutableArray array];
        for (IUObj *iu in self.children) {
            [array addObject:iu];
            [array addObjectsFromArray:iu.allChildren];
        }
        return array;
    }
    return nil;
}

-(NSDictionary*)HTMLAtributes{
    NSArray *classPedigree = [[self class] classPedigreeTo:[IUObj class]];
    NSMutableString *className = [NSMutableString stringWithString:@"'"];
    for (NSString *str in classPedigree) {
        [className appendString:str];
        [className appendString:@" "];
    }
    [className trim];
    [className appendString:@"'"];
    return @{@"class":className, @"id":self.htmlID};
}


-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width{
    return [_css tagDictionaryForWidth:(int)width];
}

//source
-(NSString*)html{
    return [self.document.compiler editorHTML:self];
}

-(NSString*)cssForWidth:(NSInteger)width{
    return [self.document.compiler CSSContentFromAttributes:[self CSSAttributesForWidth:width] ofClass:self];
}

-(void)CSSChanged:(NSDictionary*)tagDictionary forWidth:(NSInteger)width{
    if (delegateEnableLevel == 1) {
        [self.delegate IU:self.htmlID CSSChanged:[self cssForWidth:width] forWidth:width];
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

-(BOOL)addIU:(IUObj *)iu error:(NSError**)error{
    [_m_children addObject:iu];
    if (iu.delegate == nil) {
        iu.delegate = self.delegate;
    }
    iu.parent = self;
    return YES;
}

-(BOOL)addIUReference:(IUObj *)iu error:(NSError**)error{
    [_m_children addObject:iu];
    if (self.delegate) {
        iu.delegate = self.delegate;
    }
    return YES;
}


-(BOOL)removeIU:(IUObj *)iu{
    [_m_children removeObject:iu];
    return YES;
}

-(BOOL)insertIU:(IUObj *)iu atIndex:(NSInteger)index  error:(NSError**)error{
    [_m_children insertObject:iu atIndex:index];
    return YES;
}

-(NSArray*)children{
    return [_m_children copy];
}

-(void)setDelegate:(id<IUSourceDelegate>)delegate{
    _delegate = delegate;
    for (IUObj *obj in _m_children) {
        obj.delegate = delegate;
    }
}

-(IUDocument*)document{
    if (self.parent) {
        return self.parent.document;
    }
    else{
        if ([self isKindOfClass:[IUDocument class]]) {
            return (IUDocument*)self;
        }
    }
    return nil;
}

-(NSString*)description{
    return [[super description] stringByAppendingFormat:@" %@", self.htmlID];
}

- (void)moveX:(NSInteger)x Y:(NSInteger)y{
    NSInteger currentX = [_css.affectingTagCollection[IUCSSTagX] integerValue];
    currentX += x;
    [_css setValue:@(currentX) forKeyPath:[@"affectingTagCollection" stringByAppendingPathExtension:IUCSSTagX]];
    
    NSInteger currentY = [_css.affectingTagCollection[IUCSSTagY] integerValue];
    currentY += y;
    [_css setValue:@(currentY) forKeyPath:[@"affectingTagCollection" stringByAppendingPathExtension:IUCSSTagY]];
}

- (void)increaseWidth:(NSInteger)width height:(NSInteger)height{
    NSInteger currentWidth = [_css.affectingTagCollection[IUCSSTagWidth] integerValue];
    currentWidth += width;
    [_css setValue:@(currentWidth) forKeyPath:[@"affectingTagCollection" stringByAppendingPathExtension:IUCSSTagWidth]];
    
    NSInteger currentHeight = [_css.affectingTagCollection[IUCSSTagHeight] integerValue];
    currentHeight += height;
    [_css setValue:@(currentHeight) forKeyPath:[@"affectingTagCollection" stringByAppendingPathExtension:IUCSSTagHeight]];
}

@end