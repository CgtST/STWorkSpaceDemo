//
//  CTDateTools.m
//  CMTools
//
//  Created by bingo on 2018/6/13.
//  Copyright © 2018年 bingo. All rights reserved.
//

#import "CTDateTools.h"

@implementation CTDateTools


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


+ (NSDate *)getLocalDateWithCurrentDate:(NSDate *)date
{
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



+ (NSString *)getLiveDateWithTimeStrap:(NSTimeInterval)ts {
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];; //[[NSDateFormatter alloc] init];
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
