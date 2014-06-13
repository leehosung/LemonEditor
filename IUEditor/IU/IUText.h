//
//  IUText.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 26..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUBox.h"
#import "IUTextController.h"

@interface IUText : IUBox <IUTextControllerDelegate>

@property IUTextController *textController;
@property (nonatomic) BOOL lineHeightAuto;

/// text managing
- (void)updateNewLine:(NSRange)range htmlNode:(DOMHTMLElement *)node;
- (void)selectTextRange:(NSRange)range htmlNode:(DOMHTMLElement *)node;

- (NSDictionary*)textCSSAttributesForWidth:(NSInteger)width textIdentifier:(NSString *)identifier;
- (NSString*)textHTML;

- (NSArray *)fontNameArray;

@end
