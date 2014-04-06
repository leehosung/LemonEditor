//
//  JDShortcut.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ReturnNilIfFalse(a)     if((a) == NO) {NSLog(@"ReturnNilIfFalse"); return nil;};
#define ReturnNoIfFalse(a)      if((a) == NO){NSLog(@"ReturnNoIfFalse"); return NO;};
#define ReturnNilIfError(a, b)  (a);    if ((b)!=nil) return nil; 