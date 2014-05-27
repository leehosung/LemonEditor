//
//  IUCompiler.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUBox.h"
#import "IUCarousel.h"
#import "IUCompilerResourceSource.h"
#import "JDCode.h"

@class IUDocument;
@class IUResourceManager;

typedef enum _IUCompileRule{
    IUCompileRuleDefault,
    IUCompileRuleDjango,
}IUCompileRule;

@interface IUCompiler : NSObject

@property id <IUCompilerResourceSource> resourceSource;
@property IUCompileRule    rule;

//build source
-(NSString*)outputSource:(IUDocument*)document mqSizeArray:(NSArray *)mqSizeArray;
-(JDCode *)outputHTML:(IUBox *)iu;

//editor source
-(NSString*)editorSource:(IUDocument*)document mqSizeArray:(NSArray *)mqSizeArray;
-(JDCode* )editorHTML:(IUBox*)iu;

-(NSString*)CSSContentFromAttributes:(NSDictionary*)attributeDict ofClass:(IUBox*)obj isHover:(BOOL)isHover;
-(NSString *)fontCSSContentFromAttributes:(NSDictionary*)attributeDict;
-(NSDictionary *)cssDictionaryForIUCarousel:(IUCarousel *)iu;
-(NSString *)cssContentForIUCarouselPager:(IUCarousel *)iu hover:(BOOL)hover;
- (NSString *)cssContentForIUCarouselArrow:(IUCarousel *)iu hover:(BOOL)hover location:(IUCarouselArrow)location carouselHeight:(NSInteger)height;

#pragma mark manage JS source
-(NSString *)outputJSArgs:(IUBox *)iu;
-(NSString *)outputJSInitializeSource:(IUDocument *)document;
@end