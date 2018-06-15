//
//  NSDate+FLAdditions.m
//  QNEngine
//
//  Created by manny on 13-3-28.
//  Copyright (c) 2013年 Futu. All rights reserved.
//

#import "NSDate+Additions.h"
#import "HKDateFormatter.h"
#import "QNDateFormatterManager.h"

@implementation NSDate (Additions)

- (NSString *)timeString
{
    static HKDateFormatter *formatter = nil;
    if (formatter == nil)
    {
        formatter = [HKDateFormatter dateFormatter];
        [formatter setDateFormat:@"HH:mm"];
    }
    return [formatter stringFromDate: self];
}

//+ (BOOL)isEqualDateForTime:(uint32_t)time1 time2:(uint32_t)time2 withCalendar:(NSCalendar *)calendar klineDataType:(uint8_t)klineDataType
//{
//    NSCalendarUnit calUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |
//                             NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    BOOL result = NO;
//    NSDateComponents *dc1 = [calendar components:calUnit fromDate:[NSDate dateWithTimeIntervalSince1970:time1]];
//    NSDateComponents *dc2 = [calendar components:calUnit fromDate:[NSDate dateWithTimeIntervalSince1970:time2]];
//    
//    switch (klineDataType)
//    {
//        case FLKLineDataTypeKLineWeek:
//        {
//            result = (dc1.weekOfMonth == dc2.weekOfMonth) && (dc1.month == dc2.month) && (dc1.year == dc2.year);
//        }
//            break;
//        case FLKLineDataTypeKLineMonth:
//        {
//            result = (dc1.month == dc2.month) && (dc1.year == dc2.year);
//        }
//            break;
//        case FLKLineDataTypeKLineYear:
//        {
//            result = (dc1.year == dc2.year);
//        }
//            break;
//        default:
//        {
//            result = (dc1.day == dc2.day) && (dc1.month == dc2.month) && (dc1.year == dc2.year);
//        }
//            break;
//    }
//
//    return result;
//}

+ (uint32_t)normalizedToDayBeginForTime:(uint32_t)time withCalendar:(NSCalendar *)calendar
{
    NSCalendarUnit calUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dc = [calendar components:calUnit fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    dc.hour = 0;
    dc.minute = 0;
    dc.second = 0;
    return [[calendar dateFromComponents:dc] timeIntervalSince1970];
}

+ (uint32_t)normalizedToDayEndForTime:(uint32_t)time withCalendar:(NSCalendar *)calendar
{
    NSCalendarUnit calUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dc = [calendar components:calUnit fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    dc.hour = 23;
    dc.minute = 59;
    dc.second = 59;
    return [[calendar dateFromComponents:dc] timeIntervalSince1970];
}


- (uint64_t)timeIntervalSince1970_MSEC
{
    uint64_t mps = 1000;
    return [self timeIntervalSince1970] * mps;
}


- (NSString *)timerShaftString
{
    NSTimeInterval ts = [self timeIntervalSince1970];
    return [[self class] timerShaftStringWithTimeStamp: ts];
}

- (NSString *)imTimerShaftString {
    NSTimeInterval ts = [self timeIntervalSince1970];
    return [[self class] imTimerShaftStringWithTimeStamp: ts];
}

+ (NSString *)timerShaftStringWithTimeStamp:(NSTimeInterval)ts
{
//    NSDate *now     = [self getLocalDateWithCurrentDate:[NSDate date]];
//    NSDate *before  = [self getLocalDateWithCurrentDate:[NSDate dateWithTimeIntervalSince1970: ts]];
//    NSTimeInterval  nowTs = [now timeIntervalSince1970];
//    NSTimeInterval  interval = MAX(0, nowTs - ts);
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Hong_Kong"];
//    
//    static NSArray *s_strings = nil;
//    if (s_strings == nil) {
//        s_strings = @[NSLocalizedString(@"刚刚", nil),
//                      NSLocalizedString(@"分钟前", nil),
//                      NSLocalizedString(@"小时前", nil),
//                      NSLocalizedString(@"昨天", nil),
//                      NSLocalizedString(@"今天", nil)];
//    }
//    
//    NSString *timeString = nil;
//    if (interval <= SEC_PER_MINUTE * 2) {
//        timeString = s_strings[0];
//    }
//    else if (interval <= SEC_PER_HOUR) {
//        NSInteger minutes = floor(interval / SEC_PER_MINUTE);
//        timeString = [NSString stringWithFormat: @"%@%@", @(minutes), s_strings[1]];
//    }
//    else if (interval < SEC_PER_DAY) {
//        static NSDateFormatter *formatter = nil;
//        if (formatter == nil) {
//            formatter = [HKDateFormatter dateFormatter];
//            [formatter setDateFormat: @"HH:mm"];
//            [formatter setTimeZone:timeZone];
//        }
//        timeString = [formatter stringFromDate: before];
//        
//        NSCalendarUnit unit = (NSCalendarUnitYear |
//                               NSCalendarUnitMonth |
//                               NSCalendarUnitDay |
//                               NSCalendarUnitHour |
//                               NSCalendarUnitMinute);
//        NSDateComponents *nowCom = [[NSCalendar currentCalendar] components: unit
//                                                                   fromDate: now];
//        nowCom.timeZone = timeZone;
//        NSDateComponents *beforeCom = [[NSCalendar currentCalendar] components: unit
//                                                                      fromDate: before];
//        beforeCom.timeZone = timeZone;
//        if (nowCom.day == 1 || nowCom.day - beforeCom.day == 1) {
//            timeString = [NSString stringWithFormat: @"%@ %@", s_strings[3], timeString];
//        }
//        else {
//            
//            timeString = [NSString stringWithFormat: @"%@ %@", s_strings[4], timeString];
//        }
//    }
//    else {
//        static NSDateFormatter *formatter = nil;
//        if (formatter == nil) {
//            formatter = [HKDateFormatter dateFormatter];
//            [formatter setDateFormat: @"MM-dd HH:mm"];
//        }
//        timeString = [formatter stringFromDate: before];
//    }
//    return timeString;
    @try {
        //实例化一个NSDateFormatter对象
        
        if ([@(ts) stringValue].length > 11) {
            ts = ts / 1000;
        }
        
        
        NSDateFormatter *dateFormatter = GlobalDateFormatterManager(); //[[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        
        NSDate * nowDate = [self getLocalDateWithCurrentDate:[NSDate date]];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [self getLocalDateWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:ts]];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  //// 1分钟以内的
            dateStr = CustomLocalizedString(@"QGANGGANG", nil);
        }else if(time<=60*60){  ////  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d%@",mins,CustomLocalizedString(@"QFENZHONGQIAN", nil)];
            
        }else if(time <= 60*60*24){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"%@ %@",CustomLocalizedString(@"QJINTIAN", nil),[dateFormatter stringFromDate:needFormatDate]];
            }else{
                ////  昨天
                dateStr = [NSString stringWithFormat:@"%@ %@",CustomLocalizedString(@"QZUOTIAN", nil),[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }

}

/**
 *  外汇时间格式化
 */
+ (NSString *)fxTimerShaftStringWithTimeStamp:(NSTimeInterval)ts {
    @try {
        //实例化一个NSDateFormatter对象
        
        if ([@(ts) stringValue].length > 11) {
            ts = ts / 1000;
        }
        NSDateFormatter *dateFormatter = ibToolHandler().m_DateFormatter;  
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSDate * nowDate = [self getLocalDateWithCurrentDate:[NSDate date]];
        NSDate * needFormatDate = [self getLocalDateWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:ts]];
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        NSString *dateStr = @"";
        if (time<=60) {  //// 1分钟以内的
            dateStr = CustomLocalizedString(@"QGANGGANG", nil);
        }else if(time<=60*60){  ////  一个小时以内的
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d%@",mins,CustomLocalizedString(@"QFENZHONGQIAN", nil)];
        }else if(time <= 60*60*24){   //// 在两天内的
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                dateStr = [NSString stringWithFormat:@"%@ %@",CustomLocalizedString(@"QJINTIAN", nil),[dateFormatter stringFromDate:needFormatDate]];
            }else{
                dateStr = [NSString stringWithFormat:@"%@ %@",CustomLocalizedString(@"QZUOTIAN", nil),[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            if ([yearStr isEqualToString:nowYear]) {
                [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }

}



+ (NSString *)monthlyDetailTimeWithTimeStrap:(NSTimeInterval)ts {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM月dd日 HH:mm:ss";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts];
    
    return [dateFormatter stringFromDate:date];
}

+ (BOOL)moreThanOneHourToNow: (NSDate *) theDate
{
    NSTimeInterval late = [theDate timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now =[dat timeIntervalSince1970]*1;
    NSTimeInterval diff = now - late;
    if (diff/3600 > 1) {
        return YES;
    }
    return NO;
}

+ (NSDate *)getLocalDateWithCurrentDate:(NSDate *)date {
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
//    //设置转换后的目标日期时区
//    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
//    //得到源日期与世界标准时间的偏移量
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
//    //目标日期与本地时区的偏移量
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
//    //得到时间偏移量的差值
//    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//    //转为现在时间
//    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
//    return destinationDateNow;
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    return localDate;
}

+ (NSString *)imTimerShaftStringWithTimeStamp:(NSTimeInterval)ts {
    @try {
        if ([@(ts) stringValue].length > 11) {
            ts = ts / 1000;
        }
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = GlobalDateFormatterManager(); //[[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSDate * nowDate = [self getLocalDateWithCurrentDate:[NSDate date]];
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [self getLocalDateWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:ts]];
        
        NSString *dateStr = @"";
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dayStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowday = [dateFormatter stringFromDate:nowDate];
        NSString *yesterday = [dateFormatter stringFromDate:[nowDate dateByAddingTimeInterval:-60*60*24]];
        if ([dayStr isEqualToString:nowday]) {  //// 今天
            [dateFormatter setDateFormat:@"HH:mm"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else if([dayStr isEqualToString:yesterday]){  ////昨天
            [dateFormatter setDateFormat:@"昨天 HH:mm"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)imListTimerShaftStringWithTimeStamp:(NSTimeInterval)ts {
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = GlobalDateFormatterManager(); //[[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSDate * nowDate = [self getLocalDateWithCurrentDate:[NSDate date]];
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [self getLocalDateWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:ts]];
        
        NSString *dateStr = @"";
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dayStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowday = [dateFormatter stringFromDate:nowDate];
        NSString *yesterday = [dateFormatter stringFromDate:[nowDate dateByAddingTimeInterval:-60*60*24]];
        if ([dayStr isEqualToString:nowday]) {  //// 今天
            [dateFormatter setDateFormat:@"HH:mm"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else if([dayStr isEqualToString:yesterday]){  ////昨天
            [dateFormatter setDateFormat:@"昨天 HH:mm"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                //是否是同一个月
                [dateFormatter setDateFormat:@"MM"];
                NSString *monthStr = [dateFormatter stringFromDate:needFormatDate];
                NSString *nowmonth = [dateFormatter stringFromDate:nowDate];
                if ([monthStr isEqualToString:nowmonth]) {
                    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                    dateStr = [dateFormatter stringFromDate:needFormatDate];
                }else {
                    [dateFormatter setDateFormat:@"MM-dd"];
                    dateStr = [dateFormatter stringFromDate:needFormatDate];
                }
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)getLiveDateWithTimeStrap:(NSTimeInterval)ts {
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = GlobalDateFormatterManager(); //[[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSDate * nowDate = [self getLocalDateWithCurrentDate:[NSDate date]];
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [self getLocalDateWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:ts]];
        
        NSString *dateStr = @"";
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dayStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowday = [dateFormatter stringFromDate:nowDate];
        NSString *yesterday = [dateFormatter stringFromDate:[nowDate dateByAddingTimeInterval:-60*60*24]];
        if ([dayStr isEqualToString:nowday]) {  //// 今天
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else if([dayStr isEqualToString:yesterday]){  ////昨天
            [dateFormatter setDateFormat:@"昨天 HH:mm:ss"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}
+ (NSString *)dayTimeStringWithTS:(NSTimeInterval)ts {
    return [self dateWithFormat:@"HH:mm" WithTS:ts];
}

+ (NSString *)dateTimeStringWithTS:(NSTimeInterval)ts {
    return [self dateWithFormat:@"yyyy-MM-dd" WithTS:ts];
}

+ (NSString *)monthTimeStringWithTs:(NSTimeInterval)ts {
    return [self dateWithFormat:@"yyyy年MM月" WithTS:ts];
}

+ (NSString *)detailTimeStringWithTs:(NSTimeInterval)ts {
    return [self dateWithFormat:@"yyyy-MM-dd HH:mm:ss" WithTS:ts];
}


+ (NSString*)dateWithFormat:(NSString*)format WithTS:(NSTimeInterval)ts {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts];
    
    return [dateFormatter stringFromDate:date];
}



@end




