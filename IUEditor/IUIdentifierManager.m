//
//  IUIdentifierManager.m
//  IUEditor
//
//  Created by jd on 4/11/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUIdentifierManager.h"
#import "IUBox.h"

@implementation IUIdentifierManager{
    NSMutableDictionary *set;
}

-(id)init{
    self = [super init];
    set = [NSMutableDictionary dictionary];
    return self;
}

-(void)addIUs:(NSArray*)IUs{
    for (IUBox *iu in IUs) {
        [set setObject:iu forKey:iu.htmlID];
        for (IUBox *child in iu.allChildren) {
            [set setObject:child forKey:child.htmlID];
        }
    }
}

-(void)addIU:(IUBox*)iu{
    [set setObject:iu forKey:iu.htmlID];
    for (IUBox *child in iu.allChildren) {
        [set setObject:child forKey:child.htmlID];
    }
}

-(NSString*)requestNewIdentifierWithKey:(NSString*)key{
    int i=0;
    while (1) {
        i++;
        NSString *newIdentifier = [NSString stringWithFormat:@"%@%d",key, i];
        IUBox *iu = [set objectForKey:newIdentifier];
        if (iu == nil) {
            return newIdentifier;
        }
    }
}

-(void)removeIdentifier:(NSString*)identifier{
    [set removeObjectForKey:identifier];
}

@end
