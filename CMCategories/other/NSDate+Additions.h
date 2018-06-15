//
//  NSDate+FLAdditions.h
//  QNEngine
//
//  Created by manny on 13-3-28.
//  Copyright (c) 2013年 Futu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

@property(nonatomic, strong, readonly) NSString *timeString;

//+ (BOOL)isEqualDateForTime:(uint32_t)time1 time2:(uint32_t)time2 withCalendar:(NSCalendar *)calendar klineDataType:(uint8_t)klineDataType;

+ (uint32_t)normalizedToDayBeginForTime:(uint32_t)time withCalendar:(NSCalendar *)calendar;

+ (uint32_t)normalizedToDayEndForTime:(uint32_t)time withCalendar:(NSCalendar *)calendar;


/* 毫秒 */
- (uint64_t)timeIntervalSince1970_MSEC;

- (NSString *)timerShaftString;
/**
 *  IM时间显示格式化
 */
- (NSString *)imTimerShaftString;
/**
 *  IM列表时间格式化
 */
+ (NSString *)imListTimerShaftStringWithTimeStamp:(NSTimeInterval)ts;
+ (NSString *)timerShaftStringWithTimeStamp:(NSTimeInterval)ts;
/**
 *  IM时间显示格式化
 */
+ (NSString *)imTimerShaftStringWithTimeStamp:(NSTimeInterval)ts;

/**
 *  外汇时间格式化
 */
+ (NSString *)fxTimerShaftStringWithTimeStamp:(NSTimeInterval)ts;


/**
 *  时间戳转换为以月份开头的详细时间
 *  etg.4月13日 10:23:32
 *
 *  @param ts Unix 时间戳
 *
 *  @return 转换后显示时间
 */
+ (NSString *)monthlyDetailTimeWithTimeStrap:(NSTimeInterval)ts;

/**
 * 判断theDate到现在是否超过一个小时
 */
+ (BOOL)moreThanOneHourToNow: (NSDate *) theDate;

/**
 *  获取一个date的转换时区后的日期
 */
+ (NSDate *)getLocalDateWithCurrentDate:(NSDate *)date;
/**
 *  获取直播时间格式
 *
 *  @param ts 时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString *)getLiveDateWithTimeStrap:(NSTimeInterval)ts;
/**
 *  根据自定义格式返回字符串
 *
 *  @param format 日期格式
 *  @param ts     时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString*)dateWithFormat:(NSString*)format WithTS:(NSTimeInterval)ts;
/**
 *  根据unix时间戳返回当天时间,eg. 12:01.
 *
 *  @param ts unix时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString *)dayTimeStringWithTS:(NSTimeInterval)ts;
/**
 *  根据unix时间返回日期,eg. 2015-09-01
 *
 *  @param ts unix时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString *)dateTimeStringWithTS:(NSTimeInterval)ts;
/**
 *  根据unix时间返回日期,eg. 2015年09月
 *
 *  @param ts unix时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString *)monthTimeStringWithTs:(NSTimeInterval)ts;
/**
 *  根据unix时间返回日期,eg. 2015-09-10 13:00:05
 *
 *  @param ts unix时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString *)detailTimeStringWithTs:(NSTimeInterval)ts;
@end
