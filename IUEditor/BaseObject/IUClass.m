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
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUClass class] propertiesWithOutProperties:@[@"referenceArray"]]];
        _referenceArray = [[aDecoder decodeObjectForKey:@"referenceArray"] mutableCopy];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUClass class] properties]];
    
}

-(BOOL)shouldEditText{
    return NO;
}

@end
