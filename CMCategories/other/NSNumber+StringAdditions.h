//
//  NSNumber+FLAdditions.h
//  Stock
//
//  Created by Yang DeXing on 11-8-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * \brief 金额、价格、数量等数字显示的相关的接口。
 * 
 * 注意：因为 NSNumberFormatter 是线程不安全的，所以在使用下面的方法时，请确保在运行在主线程。
 */
@interface NSNumber (StringAdditions)


- (NSString *)ratioString;
- (NSString *)signedRatioString;
- (NSString *)oneFracationRatioString;
- (NSString *)integerRatioString;
- (NSString *)noPositiveIntegerRatioString;

- (NSString *)DoubleString;
- (NSString *)QNString;
- (NSString *)QNSignedString;
- (NSString *)LongString;


- (NSString *)QNKMBString;
/** 只保留3位有效数字的 KMB 字符串 */
- (NSString *)QNKMBStringWithThreeMaxSignificantDigits;


/** 百位计数法, 目前只支持“万、亿、万亿” */
+ (uint64_t)QNHundredUnitForValue:(uint64_t)value;
+ (NSString *)QNHundredUnitStringForUnit:(uint64_t)unit;
+ (NSString *)QNHundredUnitStringForValue:(uint64_t)value unit:(uint64_t)unit fractionCount:(int)fractionCount;


- (NSString *)QNChineseString;
- (NSString *)QNChineseStringWithoutFraction;
- (NSString *)QNChineseStringWithFraction:(int)fractionCount;


- (NSString *)QNPriceDisplayString;
/**
 * \param fractionCount 有效值仅为 2 和 3
 */
- (NSString *)QNPriceDisplayStringWithFractionCount:(int)fractionCount;
- (NSString *)QNFitPriceStepString;


- (NSString *)QNFiveZeroFiveFractionString;
- (NSString *)QNFiveZeroThreeFractionString;
- (NSString *)QNFiveZeroAutoFractionString;
- (NSString *)QNFiveZeroMinimalFractionString;
/**
 * 整数部分从后往前满3位加逗号，小数部分凡不满2位小数，补齐2位小数，
 * 超过2位小数，则有多少位显示多少位（港股最多3位，美股最多5位）。
 */
- (NSString *)QNFiveZeroMoneyString;
- (NSString *)QNFiveZeroMiniTwoFractionString;

- (NSString *)QNFiveZeroOneFractionString;
- (NSString *)QNFiveZeroKMBString;
- (NSString *)QNFiveZeroSignedMoneyString;

/**
 *  三位一逗号
 */
- (NSString *)QNThreeDotFractionString;



@end
