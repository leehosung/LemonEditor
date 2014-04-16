//
//  IUTextManager.h
//  IUEditor
//
//  Created by jd on 4/16/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUTextManager : NSObject

@property NSInteger editViewPortWidth;

- (void)setFont:(NSString*)name atRange:(NSRange)range;
- (void)setFontSize:(NSInteger)size atRange:(NSRange)range; // support media query
- (void)removeMediaQuery:(NSInteger)viewPortWidth;
- (void)setLink:(NSString*)url atRange:(NSRange)range;
- (void)setBoldAtRange:(NSRange)range;
- (void)setUnderbarAtRange:(NSRange)range;
- (void)setItalicAtRange:(NSRange)range;
- (void)setColor:(NSColor*)color atRange:(NSRange)range;

- (void)replaceText:(NSString*)string atRange:(NSRange)range;
- (void)deleteTextInRange:(NSRange)range;
- (void)removeMediaQuery:(NSInteger)viewPortWidth;
- (NSString*)HTML;

// css
// return key    : NSNumber with media query width
//        value  : NSDictionary with key-value
- (NSDictionary*)css;

@property NSString *idKey;
@end