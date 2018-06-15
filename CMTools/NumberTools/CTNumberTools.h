//
//  CDTNumberTools.h
//  CommonDataTools
//
//  Created by bingo on 16/10/18.
//  Copyright © 2016年 CM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTNumberTools : NSObject

#pragma mark - 小数精度

//判断小数是几位
+(NSInteger)getDoubleDec:(double)dValue;

//获取字符串值的小数位(不计算末尾的0).如果字符串不为值类型,则可能出错
+(NSUInteger)decOfValueTrim0:(nonnull NSString*)valueStr;

//double转换为字符串(2.50正值为:"2.50",负值为"-2.50")
+(nonnull NSString*)double2NString:(double)dValue withDec:(NSUInteger)idec;

// 1.235 ->1.24    1.000 -> 1
+(nonnull NSString*)double2NStringTrimO:(double)dValue withDec:(NSUInteger)idec;


#pragma mark - 缩写

//double转换为字符串，字符串中使用"亿"，"万"缩写
+(nonnull NSString*)double2NumWithUnit:(double)dValue;

#pragma mark - 与0相等

//是否与0值相等
+(BOOL)isEqualToZero:(double)dValue;  //(9位精度)

+(BOOL)isFloatEqualToZero:(float)fValue;  //（5位精度)

#pragma mark - 数值查找

+(BOOL)isNumber:(nonnull NSNumber*)curNum inArr:(nonnull NSArray<__kindof NSNumber*>*)numArr;

//NSNotFound表示没有找到
+(NSInteger)getIndex:(nonnull NSNumber*)curNum inArr:(nonnull NSArray<__kindof NSNumber*>*)numArr;


#pragma mark - 字符串相关
//任何类型的转为字符串
+(nonnull NSString *)changeStringWithId:(nonnull id)value;

//数字上用逗号隔开
+ (nonnull NSString *)addSeparatorForPriceString:(nonnull NSString *)pricestr;

@end
