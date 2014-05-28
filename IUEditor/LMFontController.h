//
//  LMFontController.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 28..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *LMFontName = @"name";
static NSString *LMFontHeaderLink = @"link";
static NSString *LMFontFamilyName = @"css";
static NSString *LMFontNeedLoad = @"isLoadable";
static NSString *LMFontEditable = @"editalbe";

@interface LMFontController : NSObject

@property NSMutableDictionary *fontDict;

+ (LMFontController *)sharedFontController;
- (void)loadFontList;
- (void)saveFontList;

- (NSString *)cssForFontName:(NSString *)fontName;
- (NSString *)headerForFontName:(NSString *)fontName;
- (BOOL)isNeedHeader:(NSString *)fontName;

@end
