//
//  IUComponent.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUSheet.h"

@class IUImport;

@interface IUClass : IUSheet

- (void)addReference:(IUImport*)import;
- (void)removeReference:(IUImport*)import;
- (NSArray*)references;
@end
