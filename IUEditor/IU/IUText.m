//
//  IUText.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 26..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUText.h"
#import "IUSheet.h"
#import "IUProject.h"

@implementation IUText{

}

- (id)copyWithZone:(NSZone *)zone{
    IUText *textIU = [super copyWithZone:zone];
    
    IUTextController *controller = [_textController copy];
    controller.textDelegate = textIU;
    textIU.textController = controller;
    textIU.lineHeightAuto = self.lineHeightAuto;
    
    return textIU;
}

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        _textController = [[IUTextController alloc] init];
        _textController.textDelegate = self;
        self.lineHeightAuto = YES;

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        _textController = [aDecoder decodeObjectForKey:@"textController"];
        _textController.textDelegate = self;
        self.lineHeightAuto = [[aDecoder decodeObjectForKey:@"lineHeightAuto"] boolValue];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.textController forKey:@"textController"];
    [aCoder encodeObject:@(self.lineHeightAuto) forKey:@"lineHeightAuto"];

}

- (void)delegate_selectedFrameWidthDidChange:(NSDictionary*)change{
    if (self.delegate) {
        if (self.delegate.maxFrameWidth == self.delegate.selectedFrameWidth) {
            [self.css setEditWidth:IUCSSMaxViewPortWidth];
            [_textController setEditWidth:IUCSSMaxViewPortWidth];
        }
        else {
            [self.css setEditWidth:self.delegate.selectedFrameWidth];
            [_textController setEditWidth:self.delegate.selectedFrameWidth];
        }
    }
}

- (NSArray *)fontNameArray{
    NSMutableArray *fontArray = [NSMutableArray array];
    
    
    NSString *fontName = [self.css valueForKeyPath:[@"assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagFontName]];
    if([fontArray containsString:fontName] == NO){
        [fontArray addObject:fontName];
    }

    [fontArray addObjectsFromArray:[_textController fontNameArray]];
    
    return fontArray;
}

#pragma mark -
#pragma mark manage text

- (BOOL)hasText{
    return YES;
}


- (void)updateNewLine:(NSRange)range htmlNode:(DOMHTMLElement *)node{
    [_textController selectTextRange:range htmlNode:node];
    [self updateCSSForEditViewPort];
    [self updateAutoHeight];
}

- (void)updateAutoHeight{
    if(self.delegate){
        [self.delegate callWebScriptMethod:@"setTextAutoHeight" withArguments:nil];
    }
}


- (void)selectTextRange:(NSRange)range htmlNode:(DOMHTMLElement *)node{
    
    [_textController selectTextRange:range htmlNode:node];
    
}

- (BOOL)shouldAddIUByUserInput{
    return NO;
}

- (void)updateHTML{
    [super updateHTML];
    [self updateAutoHeight];
}

- (void)updateTextHTML{
    [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.parent.htmlID];
    [self updateAutoHeight];
}

- (void)updateTextCSS:(IUCSS *)textCSS identifier:(NSString *)identifier{
    NSString *cssStr = [self.project.compiler fontCSSContentFromAttributes:textCSS.assembledTagDictionary];
    NSString *textIdentifier = [NSString stringWithFormat:@".%@", identifier];
    [self.delegate IUClassIdentifier:textIdentifier CSSUpdated:cssStr forWidth:textCSS.editWidth];
}

-(void)updateTextRangeFromID:(NSString *)fromID toID:(NSString *)toID{
    [self.delegate updateTextRangeFromID:fromID toID:toID];
}

-(void)removeTextCSSIdentifier:(NSString *)identifier{
    [self.delegate removeAllCSSWithIdentifier:identifier];
}

- (NSString*)textHTML{
    return _textController.textHTML;
}


-(NSDictionary*)textCSSAttributesForWidth:(NSInteger)width textIdentifier:(NSString *)identifier{
    IUCSS *css = [_textController.cssDict objectForKey:identifier];
    return [css tagDictionaryForWidth:(int)width];
}
- (void)updateCSSForEditViewPort{
    [super updateCSSForEditViewPort];
    [self updateAutoHeight];
}

- (NSString*)identifierForTextController{
    return self.htmlID;
}

#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
- (void)setLineHeightAuto:(BOOL)lineHeightAuto{
    _lineHeightAuto = lineHeightAuto;
    [self updateHTML];
}
#endif

- (NSArray *)cssIdentifierArray{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[super cssIdentifierArray]];
    
    for(NSString *identifier in self.textController.cssDict.allKeys){
        NSString *cssID = [NSString stringWithFormat:@".%@", identifier];
        [array addObject:cssID];
    }
    return array;
}

@end
