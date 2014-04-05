//
//  JDLogUtil.h
//  Mango
//
//  Created by JD on 13. 2. 6..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

#import <Foundation/Foundation.h>
// How to apply color formatting to your log statements:
//
// To set the foreground color:
// Insert the ESCAPE into your string, followed by "fg124,12,255;" where r=124, g=12, b=255.
//
// To set the background color:
// Insert the ESCAPE into your string, followed by "bg12,24,36;" where r=12, g=24, b=36.
//
// To reset the foreground color (to default value):
// Insert the ESCAPE into your string, followed by "fg;"
//
// To reset the background color (to default value):
// Insert the ESCAPE into your string, followed by "bg;"
//
// To reset the foreground and background color (to default values) in one operation:
// Insert the ESCAPE into your string, followed by ";"

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color


// JDLOGGING is set by APPLE LLVM in Build Setting when Debug mode
// JDLOGGING is not set when Release mode
#ifdef JDLOGGING
//default log
#define JDLog(level, format, ...) \
    [JDLogUtil log:(int)level\
            fromFile:[@__FILE__ lastPathComponent]\
        fromFunction:__PRETTY_FUNCTION__\
            fromLine:__LINE__\
        withMessage:[NSString stringWithFormat:(format), ##__VA_ARGS__]]

//section log
#define JDSectionLog(theLevel, sectionName, format, ...) \
    [JDLogUtil sectionLog:(NSString *)sectionName \
                    level:(int)theLevel \
                fromFile:[@__FILE__ lastPathComponent] \
            fromFunction:__PRETTY_FUNCTION__ \
                fromLine:__LINE__ \
            withMessage:[NSString stringWithFormat:(format), ##__VA_ARGS__]]


#else

#define JDLog(...)
#define JDSectionLog(...)

#endif

#define JDFatalLog(format, ...) JDLog(JDLog_Level_Fatal, format, ##__VA_ARGS__)
#define JDErrorLog(format, ...) JDLog(JDLog_Level_Error, format, ##__VA_ARGS__)
#define JDWarnLog(format, ...) JDLog(JDLog_Level_Warn, format, ##__VA_ARGS__)
#define JDInfoLog(format, ...) JDLog(JDLog_Level_Info, format, ##__VA_ARGS__)
#define JDDebugLog(format, ...) JDLog(JDLog_Level_Debug, format, ##__VA_ARGS__)
#define JDTraceLog(format, ...) JDLog(JDLog_Level_Trace, format, ##__VA_ARGS__)

#define JDSectionWarnLog(sectionName, format, ...)      JDSectionLog(JDLog_Level_Warn, sectionName, format, ##__VA_ARGS__)
#define JDSectionInfoLog(sectionName, format, ...)      JDSectionLog(JDLog_Level_Info, sectionName, format, ##__VA_ARGS__)
#define JDSectionDebugLog(sectionName, format, ...)     JDSectionLog(JDLog_Level_Debug, sectionName, format, ##__VA_ARGS__)
#define JLog JDSectionDebugLog
#define JDSectionTraceLog(sectionName, format, ...)     JDSectionLog(JDLog_Level_Trace, sectionName, format, ##__VA_ARGS__)

typedef enum {
    JDLog_Off = 0,
    JDLog_Level_Fatal,
    JDLog_Level_Error,
	JDLog_Level_Warn,
    JDLog_Level_Info,
    JDLog_Level_Debug,
    JDLog_Level_Trace,
} JDLog_Level;

@interface JDLogUtil : NSObject

//initialize
/* Usage
 1. set show log : loglevel, filename, functionane, linenumber;
 *  [JDLogUtil showLogLevel:YES andFileName:YES andFunctionName:YES andLineNumber:YES];
 2. set log level
 *  [JDLogUtil setGlobalLevel:JDLog_Level_Debug];
 3. set section log
 *   [JDLogUtil enableLogSection:IULogSource];
 *   [JDLogUtil enableLogSection:IULogJS];
 */

+(void)setGlobalLevel:(JDLog_Level)level;
+(void)enableLogSection:(NSString*)logSection;
+(void)showLogLevel:(BOOL)showLevel andFileName:(BOOL)showFileName andFunctionName:(BOOL)showFunctionName  andLineNumber:(BOOL)showLineNumber;

//call by macro 
+(void)log:(int)atLevel fromFile:(NSString *)theFile fromFunction:(const char [])theFunction fromLine:(int)theLine withMessage:(NSString *)theMessage;
+(void)sectionLog:(NSString *)section level:(int)atLevel fromFile:(NSString *)theFile fromFunction:(const char [])theFunction fromLine:(int)theLine withMessage:(NSString *)theMessage;


//call by directly
+(void)log:(NSString*)key err:(NSError*)err;

+(void)alert:(NSString*)alertMsg;
+(void)alert:(NSString*)alertMsg title:(NSString*)title;


+(void)log:(NSString*)logSection key:(NSString*)key string:(NSString*)log;
+(void)log:(NSString*)logSection key:(NSString*)key frame:(NSRect)frame;
+(void)log:(NSString*)logSection key:(NSString*)key point:(NSPoint)point;
+(void)log:(NSString*)logSection key:(NSString*)key size:(NSSize)size;


@end