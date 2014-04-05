//
//  IUView.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUView.h"

@implementation IUView{
    NSMutableArray *_children;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_children forKey:@"children"];
}

-(id)initWithProject:(IUProject *)project setting:(NSDictionary *)setting{
    self = [super initWithProject:project setting:setting];
    _children = [NSMutableArray array];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _children = [aDecoder decodeObjectForKey:@"children"];
    return self;
}

-(BOOL)addIU:(IUObj *)iu error:(NSError**)error{
    [_children addObject:iu];
    iu.delegate = self.delegate;
    return YES;
}

-(BOOL)removeIU:(IUObj *)iu{
    [_children removeObject:iu];
    return YES;
}

-(BOOL)insertIU:(IUObj *)iu atIndex:(NSInteger)index  error:(NSError**)error{
    [_children insertObject:iu atIndex:index];
    return YES;
}

-(NSMutableArray*)children{
    return _children;
}

-(void)setDelegate:(id<IUDelegate>)delegate{
    [super setDelegate:delegate];
    for (IUObj *obj in self.children) {
        obj.delegate = delegate;
    }
}

@end
