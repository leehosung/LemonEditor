//
//  IUComponent.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUClass.h"

@implementation IUClass

-(id)initWithManager:(IUIdentifierManager*)manager option:(NSDictionary *)option{
    self = [super initWithManager:manager option:option];
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

-(BOOL)shouldEditText{
    return NO;
}

-(IUBox*)parent{
    return nil;
}


@end
