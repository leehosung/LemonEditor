//
//  LMFontController.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 28..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMFontController.h"

static LMFontController *gFontController = nil;


@implementation LMFontController

+ (LMFontController *)sharedFontController{
    if(gFontController == nil){
        gFontController = [[LMFontController alloc] init];
        [gFontController loadFontList];
    }
    return gFontController;
}

- (void)initializeFontList{

    NSString *fontListPath = [[NSBundle mainBundle] pathForResource:@"defaultFont" ofType:@"plist"];
    NSDictionary *defaultFontList = [NSDictionary dictionaryWithContentsOfFile:fontListPath];
    _fontDict = [defaultFontList mutableCopy];
//    [self saveFontList];
}

- (void)loadFontList{
    //TODO: 나중에 정리
    [self initializeFontList];
    NSDictionary *userFontDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontList"];
    if(userFontDict == nil || userFontDict.count == 0){
        [self initializeFontList];
    }
    else{
        _fontDict = [userFontDict mutableCopy];
    }
}

- (void)saveFontList{
    
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:_fontDict forKey:@"fontList"];
    
}

- (NSString *)cssForFontName:(NSString *)fontName{
    return [_fontDict objectForKey:fontName][LMFontFamilyName];
}

- (NSString *)headerForFontName:(NSString *)fontName{
    return [_fontDict objectForKey:fontName][LMFontHeaderLink];
}
- (BOOL)isNeedHeader:(NSString *)fontName{
    
    if([_fontDict objectForKey:fontName]){
        return [[_fontDict objectForKey:fontName][LMFontNeedLoad] boolValue];
    }
    return NO;

}

@end
