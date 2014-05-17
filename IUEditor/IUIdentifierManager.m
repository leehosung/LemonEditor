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
    for(IUBox *iu in set.allValues){
        if(iu.parent == nil
           && [self isDocumentclass:iu] == NO){
            [self removeIdentifier:iu.htmlID];
        }
    }
}

-(NSString*)requestNewIdentifierWithKey:(NSString*)key{
    //check for failed iu(reject from drop)
    [self checkRejectedIUs];
    
    int i=0;
    while (1) {
        i++;
        if ([[key substringToIndex:2] isEqualTo:@"IU"]) {
            key = [key substringFromIndex:2];
        }
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
