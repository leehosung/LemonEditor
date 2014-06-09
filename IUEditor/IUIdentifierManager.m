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
    NSMutableDictionary *confirmed;
    NSMutableDictionary *unconfirmed;
}

-(id)init{
    self = [super init];
    confirmed = [NSMutableDictionary dictionary];
    unconfirmed = [NSMutableDictionary dictionary];
    return self;
}

-(void)resetUnconfirmedIUs{
    [unconfirmed removeAllObjects];
}

-(void)unregisterIUs:(NSArray*)IUs{
    for (IUBox *box in IUs) {
        [confirmed removeObjectForKey:box.htmlID];
        for (IUBox *child in box.allChildren) {
            [confirmed removeObjectForKey:child.htmlID];
        }
    }
}

-(void)confirm{
    for (id key in unconfirmed) {
        confirmed[key] = unconfirmed[key];
    }
}

-(void)registerIUs:(NSArray*)IUs{
    for (IUBox *iu in IUs) {
        [confirmed setObject:iu forKey:iu.htmlID];
        for (IUBox *child in iu.allChildren) {
            [confirmed setObject:child forKey:child.htmlID];
        }
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


- (NSString *)newIdentifierWithKey:(NSString *)key{
    int i=0;
    while (1) {
        i++;
        if ([[key substringToIndex:2] isEqualTo:@"IU"]) {
            key = [key substringFromIndex:2];
        }
        NSString *newIdentifier = [NSString stringWithFormat:@"%@%d",key, i];
        IUBox *existedIU = [confirmed objectForKey:newIdentifier];
        if (existedIU == nil) {
            IUBox *tempIU = [unconfirmed objectForKey:newIdentifier];
            if (tempIU == nil) {
                return newIdentifier;
            }
        }
        
        if (i > 10000){
            //while loop break;
            //the maximum number of iu : 10000
            break;
        }
    }
    return nil;
}


- (void)setNewIdentifierAndRegisterToTemp:(IUBox*)obj withKey:(NSString*)keyString;
{
    NSString *key = obj.className;
    if (keyString) {
        key = [key stringByAppendingString:keyString];
    }
    
    obj.htmlID = [self newIdentifierWithKey:key];
    assert(obj.htmlID);
    
    unconfirmed[obj.htmlID] = obj;
}

-(IUBox*)IUWithIdentifier:(NSString*)identifier{
    return [confirmed objectForKey:identifier];
}

@end
