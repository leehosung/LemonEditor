//
//  IUEventVariable.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 25..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUSheet.h"

@interface IUEventVariable : NSObject

- (void)makeEventDictionary:(IUSheet *)document;
- (NSString *)outputEventJSSource;

@end
