//
//  JDDateTimeUtil.h
//  Mango
//
//  Created by JD on 13. 2. 8..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

typedef enum _JDDateDay {
	JDDateDaySunday=1,
	JDDateDayMonday=2,
	JDDateDayTuesday=3,
	JDDateDayWednesday=4,
	JDDateDayThursday=5,
	JDDateDayFriday=6,
	JDDateDaySaterday=7,
} JDDateDay;


typedef enum _JDDateStringType {
    JDDateStringDefaultType, //2010/05/21
    JDDateStringKorType,  //2010년 5월 21일
    JDDateStringKorType2, //YYYY.M.d (수)
    JDDateStringKorType3, //10월 3일 (목)
    JDDateStringBasicType, //20100521
    JDDateStringTimestampType,	//2011-01-03 13:23:25
    JDDateStringTimestampType2	//2011-01-03  at 13.23.25 PM
} JDDateStringType;

@interface JDDateTimeUtil : NSObject {
    
}
+(NSInteger) hour;
+(NSInteger) hour :  (NSDate*) date;
+(NSInteger) month :  (NSDate*) date;
+(NSInteger) day : (NSDate*) date;
+(NSInteger) year :  (NSDate*) date;
+(NSInteger) month;
+(NSInteger) day;
+(NSInteger) year;

+(JDDateDay) weekDay : (NSDate*) date;
+(NSString*) weekDayStr:(NSDate *)date;

+(NSDate *) dateForString : (NSString*)dateString option:(JDDateStringType) option;
+(NSDate *) datePlusDay :(int) day  originDate:(NSDate*) date;
+(NSDate *) setYear:(NSInteger)year setMonth:(NSInteger)month setDay:(NSInteger)day;
+(NSDate *) getZeroDate : (NSDate *)date;
+(NSInteger) dayDiffFrom:(NSDate*)from  to:(NSDate*) to;
+(NSDate *) getDateOfThisWeek:(JDDateDay)day;
+(NSDate *) getDateOfRefWeek:(JDDateDay)day referenceWeek:(NSDate*)date;

+(NSString *) stringForDate: (NSDate *)date;
+(NSString *) stringForDate: (NSDate *)date option:(int) option;

+(NSString *) stringForToday;
+(NSString *) stringForTime: (NSDate *)date;
+(NSString *) stringForNow;

@end

