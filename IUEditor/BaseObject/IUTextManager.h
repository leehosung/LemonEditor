//
//  IUTextManager.h
//  IUEditor
//
//  Created by jd on 4/16/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IUTextInfoFont @"font"
#define IUTextInfoFontSize @"font-size"

@protocol IUTextManagerDataSource <NSObject>
- (NSString*)identifierForTextManager;
@end

@interface IUTextManager : NSObject <NSCopying>

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
- (NSString*)HTML;


- (NSDictionary*)fontInfoAtPoint:(NSUInteger)point;

// text edit 을 통하여 텍스트를 부분적으로 변화시킬때를 대비한 함수
- (void)prepareTextFont:(NSString*)name;
- (void)prepareTextFontSize:(NSUInteger)size;
- (void)insertString:(NSString*)at atIndex:(NSUInteger)index;

// css
// return key    : NSNumber with media query width
//        value  : NSDictionary with key-value
- (NSDictionary*)css;

#define IUTextCursorLocationID    @"id"
#define IUTextCursorLocationIndex @"index"
- (NSDictionary*)cursor;

@property (weak) id <IUTextManagerDataSource> dataSource;
@end