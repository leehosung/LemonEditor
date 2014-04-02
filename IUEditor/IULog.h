//
//  IULog.h
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 24..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUG 1
#ifdef DEBUG
#   define IULog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define IULog(...)
#endif
