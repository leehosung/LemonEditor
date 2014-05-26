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

/// text managing

- (void)selectTextRange:(NSRange)range htmlNode:(DOMHTMLElement *)node;
- (void)deselectText;

- (NSDictionary*)textCSSAttributesForWidth:(NSInteger)width textIdentifier:(NSString *)identifier;
- (NSString*)textHTML;

@end
