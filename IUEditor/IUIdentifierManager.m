//
//  IUIdentifierManager.m
//  IUEditor
//
//  Created by jd on 4/11/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUIdentifierManager.h"
#import "IUBox.h"
#import "IUDocument.h"
#import "IUBackground.h"
#import "IUClass.h"


@implementation IUIdentifierManager{
    NSMutableDictionary *set;
}

-(id)init{
    self = [super init];
    set = [NSMutableDictionary dictionary];
    return self;
}

-(void)registerIUs:(NSArray*)IUs{
    for (IUBox *iu in IUs) {
        [set setObject:iu forKey:iu.htmlID];
        for (IUBox *child in iu.allChildren) {
            [set setObject:child forKey:child.htmlID];
        }
    }
}

-(void)registerIU:(IUBox*)iu{
    [set setObject:iu forKey:iu.htmlID];
    for (IUBox *child in iu.allChildren) {
        [set setObject:child forKey:child.htmlID];
    }
}

- (BOOL)isDocumentclass:(IUBox *)iu{
    if([iu isKindOfClass:[IUDocument class]]
       || [iu isKindOfClass:[IUBackground class]]
       || [iu isKindOfClass:[IUClass class]]){
        return YES;
    }
    return NO;
}

- (void)checkRejectedIUs{
    NSMutableArray *deleteArray = [NSMutableArray array];
    for(IUBox *iu in set.allValues){
        if(iu.parent == nil
           && [self isDocumentclass:iu] == NO){
            [deleteArray addObject:iu.htmlID];
        }
    }
    [set removeObjectsForKeys:deleteArray];
}

- (NSString *)newIdentifierWithKey:(NSString *)key{
    int i=0;
    while (1) {
        i++;
        if ([[key substringToIndex:2] isEqualTo:@"IU"]) {
            key = [key substringFromIndex:2];
        }
        NSString *newIdentifier = [NSString stringWithFormat:@"%@%d",key, i];
        IUBox *existedIU = [set objectForKey:newIdentifier];
        if (existedIU == nil) {
            return newIdentifier;
        }
        
        if (i > 10000){
            //while loop break;
            //the maximum number of iu : 10000
            break;
        }
    }
    return nil;
}

- (void)setNewIdentifierAndRegister:(IUBox*)obj withKey:(NSString*)keyString;
{
    [self checkRejectedIUs];
    
    //children이 있는 iu가 만들어질때 children도 naming할당
    for (IUBox *iu in [obj allChildren]) {
        iu.htmlID = [self newIdentifierWithKey:iu.className];
    }
    
    NSString *key = obj.className;
    if (keyString) {
        key = [key stringByAppendingString:keyString];
    }
    
    obj.htmlID = [self newIdentifierWithKey:key];
    
    assert(obj.htmlID);
    [self registerIU:obj];
}

-(void)removeIdentifier:(NSString*)identifier{
    [set removeObjectForKey:identifier];
}

@end
