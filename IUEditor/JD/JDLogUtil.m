//
//  JDLogUtil.m
//  Mango
//
//  Created by JD on 13. 2. 6..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDLogUtil.h"

@implementation JDLogUtil

+(void)log:(NSString*)logSection log:(NSString*)log{
    NSLog(@"%@: %@", logSection, log);
}

+(void)log:(NSString*)logSection frame:(NSRect)frame{
    NSLog(@"%@: fr <%.2f,%.2f,%.2f,%.2f>", logSection, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

+(void)log:(NSString*)logSection point:(NSPoint)point{
    NSLog(@"%@: pt: <%.1f, %.1f>", logSection, point.x, point.y);
}

+(void)log:(NSString*)logSection size:(NSSize)size{
    NSLog(@"%@: sz: <%.1f, %.1f>", logSection, size.width, size.height);
}

+(void)log:(NSString*)logSection color:(NSColor*)color{
//    NSLog(@"%@: rgba: <%.1f, %.1f, %.1f, %.1f>", logSection, color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent );
}

+(void)log:(NSString*)logSection err:(NSError*)err{
    NSLog(@"%@: ERR %@",logSection, err.localizedFailureReason);
}

+(void)alert:(NSString*)alertMsg{
    [self alert:alertMsg title:@"Alert"];
}

+(void)alert:(NSString*)alertMsg title:(NSString*)title{
    if ([alertMsg length] > 401) {
        alertMsg = [alertMsg substringToIndex:400];
    }

    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:alertMsg,nil];
        [alert runModal];
    });
}

@end
