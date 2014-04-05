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

@implementation IUObj{
    int delegateEnableLevel;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUObj class] propertiesWithOut:@[@"delegate"]]];
        _css = [aDecoder decodeObjectForKey:@"css"];
        _css.delegate = self;
        delegateEnableLevel = 1;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if ([self.htmlID length] == 0) {
        assert(0);
    }
    [aCoder encodeFromObject:self withProperties:[[IUObj class] properties]];
    [aCoder encodeObject:self.css forKey:@"css"];
}

-(id)initWithProject:(IUProject*)project setting:(NSDictionary*)setting{
    self = [super init];{
        _project = project;
        _css = [[IUCSS alloc] init];
        _css.delegate = self;
        
        [_css setValue:@(50+rand()%300) forTag:IUCSSTagWidth forWidth:IUCSSDefaultCollection];
        [_css setValue:@(35) forTag:IUCSSTagHeight forWidth:IUCSSDefaultCollection];
        [_css setValue:[NSColor randomColor] forTag:IUCSSTagBGColor forWidth:IUCSSDefaultCollection];
        delegateEnableLevel = 1;
    }
    return self;
}



-(id)init{
    assert(0);
    return nil;
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
    return [self.project.compiler editorHTML:self];
}

-(NSString*)cssForWidth:(NSInteger)width{
    return [self.project.compiler CSSContentFromAttributes:[self CSSAttributesForWidth:width]];
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



@end