//
//  JDEnvUtil.m
//  Mango
//
//  Created by JD on 13. 5. 18..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDEnvUtil.h"

@implementation JDEnvUtil
+(BOOL) isFirstExecution:(NSString *)tag{
    
    NSString *testTag = [NSString stringWithFormat:@"firstExcutionTestTag%@", tag];
    
    if  ([[NSUserDefaults standardUserDefaults] boolForKey:testTag] == NO){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:testTag];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    else {
        return NO;
    }
}
@end
