//
//  JDDateTimeUtil.m
//  Mango
//
//  Created by JD on 13. 2. 8..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDDateTimeUtil.h"


#import <Foundation/Foundation.h>
//
//  JDDateTimeUtil.m
//  WonDiet
//
//  Created by jdyang on 10. 12. 6..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@implementation JDDateTimeUtil

#pragma mark TIME UTIL
+(JDDateDay) weekDay : (NSDate*) date{
	if (date==nil) {
		date=[NSDate date];
	}
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	// Get the date
	NSDate* now = (date==nil) ? [NSDate date]: date;
	// Get the hours, minutes, seconds
	NSDateComponents* nowWeek = [cal components:NSWeekdayCalendarUnit fromDate:now];
	return (JDDateDay)[nowWeek weekday];
}

+(NSDate *) getDateOfRefWeek:(JDDateDay)day referenceWeek:(NSDate*)date{
	JDDateDay weekday=[JDDateTimeUtil weekDay:date];
	//if today is wed, I want monday:
	// day = mon (2), weekday = wed (4)
	// today(wed, 4) - mon (2) = 2
	// today - today_day(4)+wantday(2) = today - 2 = return value!
	return [self datePlusDay:day-weekday originDate:date];
}

+(NSDate *) getDateOfThisWeek:(JDDateDay)day{
	return [self getDateOfRefWeek:(JDDateDay)day referenceWeek:[NSDate date]];
}

+(NSString*) weekDayStr:(NSDate *)date{
	if (date==nil) {
		date=[NSDate date];
	}
	int day=[self weekDay:date];
	switch (day) {
		case 2:
			return NSLocalizedString(@"월",@"");
		case 3:
			return NSLocalizedString(@"화",@"");
		case 4:
			return NSLocalizedString(@"수",@"");
		case 5:
			return NSLocalizedString(@"목",@"");
		case 6:
			return NSLocalizedString(@"금",@"");
		case 7:
			return NSLocalizedString(@"토",@"");
		case 1:
		default:
			return NSLocalizedString(@"일",@"");
	}
}

+(NSInteger) month{
	return [self month:nil];
}
+(NSInteger) day{
	return [self day:nil];
}
+(NSInteger) year{
	return [self year:nil];
}


+(NSDate *) setYear:(NSInteger)year setMonth:(NSInteger)month setDay:(NSInteger)day{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:year];
	[comps setMonth:month];
	[comps setDay:day];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps]  ;
	return date ;
}

+(NSInteger)hour:(NSDate*) date{
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	// Get the hours, minutes, seconds
	NSDateComponents* nowHour = [cal components:NSHourCalendarUnit fromDate:date];
	return nowHour.hour;
}

+(NSInteger)hour{
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	// Get the date
	NSDate* now = [NSDate date];
	// Get the hours, minutes, seconds
	NSDateComponents* nowHour = [cal components:NSHourCalendarUnit fromDate:now];
	return nowHour.hour;
}

+(NSInteger)month : (NSDate*) date{
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	// Get the date
	NSDate* now = (date==nil) ? [NSDate date]: date;
	// Get the hours, minutes, seconds
	NSDateComponents* nowMonth = [cal components:NSMonthCalendarUnit fromDate:now];
	return nowMonth.month;
}

+(NSInteger)day: (NSDate*) date{
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	// Get the date
	NSDate* now = (date==nil) ? [NSDate date]: date;
	// Get the hours, minutes, seconds
	NSDateComponents* nowDay = [cal components:NSDayCalendarUnit fromDate:now];
	return nowDay.day;
}

+(NSInteger)year: (NSDate*) date{
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	// Get the date
	NSDate* now = (date==nil) ? [NSDate date]: date;
	// Get the hours, minutes, seconds
	NSDateComponents* nowYear = [cal components:NSYearCalendarUnit fromDate:now];
	return nowYear.year;
}

+(NSDate *) datePlusDay :(int) day  originDate:(NSDate*) date{
	//NSDate *returnDt=[NSDate alloc
	if (date==nil) {
		return [NSDate dateWithTimeIntervalSinceNow:24*60*60*day];
	}
	else {
		return [NSDate dateWithTimeInterval: 24*60*60*day sinceDate:date] ;
	}
}

+(NSInteger) dayDiffFrom:(NSDate*)from  to:(NSDate*) to{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps2 = [gregorian components:NSDayCalendarUnit fromDate:from  toDate:to  options:0];
	return [comps2 day]; // 날짜 차이
	
}

+(NSDate *) dateForString : (NSString*)dateString option:(JDDateStringType) option {
	//timestampstr : 2011-01-03 13:23:25
	NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
	switch (option) {
		case JDDateStringTimestampType:
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			return [dateFormat dateFromString:dateString];
		default:
			break;
	}
	return nil;
}

//default : return as 2010/05/21
//option 1 : return as 2010년 5월 21일

+(NSString *) stringForDate: (NSDate *)date{
	return [self stringForDate:date option:JDDateStringDefaultType];
}
+(NSString *) stringForDate: (NSDate *)date option:(int) option{
	if (date==nil) {
		return nil;
	}
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	switch (option) {
		case JDDateStringDefaultType:
			[dateFormat setDateFormat:@"YYYY/MM/dd"];
			break;
		case JDDateStringBasicType:
			[dateFormat setDateFormat:@"YYYYMMdd"];
			break;
		case JDDateStringKorType:
			[dateFormat setDateFormat:@"YYYY년 M월 d일"];
			break;
		case JDDateStringKorType2:
			[dateFormat setDateFormat:@"YYYY.M.d "];
			break;
		case JDDateStringKorType3:
			[dateFormat setDateFormat:@"M월 d일 "];
			break;
        case JDDateStringTimestampType2://2011-01-03  at 13.23.25 PM
            [dateFormat setDateFormat:@"YYYY-MM-dd at HH.mm.ss a"];
            break;
        default:
            NSAssert(0, @"not handled");
	}
	NSMutableString *dateString =[NSMutableString stringWithString: [dateFormat stringFromDate:date]];
	if (option==JDDateStringKorType2 || option==JDDateStringKorType3) {
		[dateString appendString:[NSString stringWithFormat:@"(%@)", [self weekDayStr:date]]];
	}
    if (option == JDDateStringTimestampType2) {
        [dateString appendString:@" at "];
        [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
        NSString *timeString = [dateFormat stringFromDate:date];
        [dateString appendString:[timeString stringByReplacingOccurrencesOfString:@":" withString:@"."]];
    }

	return dateString;
}
+(NSString *) stringForToday{
	return [self stringForDate:[NSDate date]];
}

//return as PM 3:24:59
+(NSString *) stringForTime: (NSDate *)date{
	if (date==nil) {
		return nil;
	}
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"a hh:mm:ss"];
	NSString *dateString = [dateFormat stringFromDate:date];
	return dateString;
}
+(NSString *) stringForNow{
	return [self stringForTime:[NSDate date]];
}

+(NSDate*) getZeroDate:(NSDate *)date{
	NSInteger year=[self year:date];
	NSInteger month=[self month:date];
	NSInteger day=[self day:date];
	NSDate *a=[self setYear:year setMonth:month setDay:day];
	return a;
}

@end