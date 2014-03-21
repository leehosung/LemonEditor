//
//  JDLogUtil.h
//  Mango
//
//  Created by JD on 13. 2. 6..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

@interface JDLogUtil : NSObject

+(void)log:(NSString*)logSection log:(NSString*)log;
+(void)log:(NSString*)logSection frame:(NSRect)frame;
+(void)log:(NSString*)logSection size:(NSSize)size;
+(void)log:(NSString*)logSection point:(NSPoint)point;
+(void)log:(NSString*)logSection color:(NSColor*)color;
+(void)log:(NSString*)logSection err:(NSError*)err;

+(void)alert:(NSString*)alertMsg;
+(void)alert:(NSString*)alertMsg title:(NSString*)title;


@end