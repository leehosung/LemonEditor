//
//  NSDictionary+JDExtension.m
//  IUEditor
//
//  Created by JD on 3/19/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSDictionary+JDExtension.h"
#import "JDLogUtil.h"

@implementation NSDictionary (JDExtension)

-(BOOL)writeAsJSONFile:(NSString *)path atomically:(BOOL)atomically{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        [JDLogUtil log:@"WriteAsJSONFile" err:error];
        return NO;
    }
    return [data writeToFile:path atomically:atomically];
}

+(NSDictionary*)dictionaryWithJSONContentsOfFile:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        [JDLogUtil log:@"dictionaryWithJSONContentsOfFile" err:error];
        return nil;
    }
    return dict;
}
@end

@implementation NSMutableDictionary (JDExtension)

- (void)setOrRemoveObject:(id)object forKey:(id)key{
    if (object == nil) {
        [self removeObjectForKey:key];
        return;
    }
    [self setObject:object forKey:key];
}


@end