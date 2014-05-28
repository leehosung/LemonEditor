//
//  LMFontController.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 28..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMFontController : NSObject

@property NSMutableDictionary *fontDict;

+ (LMFontController *)sharedFontController;
- (void)loadFontList;
- (void)saveFontList;

@end
