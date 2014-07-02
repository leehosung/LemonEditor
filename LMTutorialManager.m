//
//  LMTutorialManager.m
//  IUEditor
//
//  Created by jd on 7/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMTutorialManager.h"

@implementation LMTutorialManager

/**
 Show tutorial if that tutorial haven't seen.
 @param tutorialID toturialID to show
 @note If that tutorial is seen, this function does not do anything.
 */

+ (BOOL)shouldShowTutorial:(NSString*)tutorialID{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialIgnore"]) {
        return NO;
    }
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Tutorial"] mutableCopy];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    BOOL shown = [[dict objectForKey:tutorialID] boolValue];
    if (shown) {
        return NO;
    }
    else{
        [dict setObject:@(YES) forKey:tutorialID];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"Tutorial"];
        return YES;
    }
}

/**
 Reset all show tutorial history.
 */
+ (void)reset{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:@"Tutorial"];
}

/**
 Ignore all showTutorial: message.
 @note This function is opposite to unIgnore function.
 */

+ (void)ignore{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TutorialIgnore"];
}

/**
 Show tutorial if showTutorial message comes.
 @note This function is opposite to ignore function.
 */
+ (void)unIgnore{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TutorialIgnore"];
}

@end
