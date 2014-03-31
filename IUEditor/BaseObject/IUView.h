//
//  IUView.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUObj.h"

@interface IUView : IUObj

@property (readonly) NSMutableArray *children;
@property (readonly) BOOL   textEditable;

-(void)undoRemoveIU:(IUObj *)iu index:(NSInteger)index;

-(BOOL)addIU:(IUObj *)iu error:(NSError**)error;
-(BOOL)insertIU:(IUObj *)iu atIndex:(NSInteger)index  error:(NSError**)error;
-(BOOL)removeIU:(IUObj *)iu;

-(void)moveIU:(IUObj*)IUObj to:(NSInteger)zIndex;

@end