//
//  IUEventVariable.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 25..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUDocument.h"

@interface IUEventVariable : NSObject

- (void)makeEventDictionary:(IUDocument *)document;
- (NSString *)outputEventJSSource;

@end
