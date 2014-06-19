//
//  IUComponent.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUClass.h"

@implementation IUClass{
    NSMutableArray *_referenceImports;
}

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        _referenceImports = [NSMutableArray array];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        _referenceImports = [[aDecoder decodeObjectForKey:@"referenceImport"] mutableCopy];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_referenceImports forKey:@"referenceImport"];
}


-(BOOL)canChangeWidthByUserInput{
    return YES;
}

-(BOOL)canChangeHeightByUserInput{
    return YES;
}

- (void)addReference:(IUImport*)import{
    [_referenceImports addObject:import];
}
- (void)removeReference:(IUImport*)import{
    [_referenceImports removeObject:import];
}

- (NSArray*)references{
    return [_referenceImports copy];
}



@end
