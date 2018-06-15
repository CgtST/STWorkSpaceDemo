//
//  NSNumber+FLAdditions.m
//  Stock
//
//  Created by Yang DeXing on 11-8-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+StringAdditions.h"
#import "QNEConstants.h"


@implementation NSNumber (StringAdditions)


- (NSString *)ratioString
{
    double value = [self doubleValue];
    if (value == DEFAULT_DOUBLEVALUE) {
        return @"--";
    }
    return [NSString stringWithFormat: @"%.2f%%", 100 * value];
}
- (NSString *)signedRatioString
{
    double value = [self doubleValue];
    if (value == DEFAULT_DOUBLEVALUE) {
        return @"--";
    }
    NSString * result = [NSString stringWithFormat: @"%+.2f%%", 100 * value];
    if ([result isEqualToString:@"+0.00%"] || [result isEqualToString:@"-0.00%"]) {
        return @"0.00%";
    }
    return result;
}
- (NSString *)oneFracationRatioString
{
    double value = [self doubleValue];
    if (value == DEFAULT_DOUBLEVALUE) {
        return @"--";
    }
    return [NSString stringWithFormat: @"%.1f%%", 100 * value];
}
- (NSString *)integerRatioString
{
    double value = [self doubleValue];
    if (value == DEFAULT_DOUBLEVALUE) {
        return @"--";
    }
    NSString *positive = value >0 ? @"+":@"";
    return [NSString stringWithFormat: @"%@%.0f%%",positive, 100 * value];
}

- (NSString *)noPositiveIntegerRatioString
{
    double value = [self doubleValue];
    if (value == DEFAULT_DOUBLEVALUE) {
        return @"--";
    }
    return [NSString stringWithFormat: @"%.0f%%", 100 * value];
}

- (NSString *)DoubleString
{
    double value = [self doubleValue];
    if (value == DEFAULT_DOUBLEVALUE) {
        return @"--";
    }
    return [NSString stringWithFormat: @"%.3f", value];
}

- (NSString *)LongString
{
    long value = [self longValue];
    if (value == LONG_MAX) {
        return @"--";
    }
    return [NSString stringWithFormat: @"%ld", value];
}

- (NSString *)QNString
{
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil)
    {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            [formatter setGroupingSize:3];
            [formatter setGroupingSeparator:@","];
            [formatter setUsesGroupingSeparator:YES];
            [formatter setMaximumFractionDigits:3];
            [formatter setMinimumFractionDigits:0];
            [formatter setMinimumIntegerDigits:1];
        });
        
    }
    return [formatter stringFromNumber:self];
}

- (NSString *)QNSignedString
{
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil)
    {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            [formatter setGroupingSize:3];
            [formatter setGroupingSeparator:@","];
            [formatter setUsesGroupingSeparator:YES];
            [formatter setMaximumFractionDigits:3];
            [formatter setMinimumFractionDigits:2];
            [formatter setMinimumIntegerDigits:1];
            [formatter setPositivePrefix:@"+"];
        });
    }
    return [formatter stringFromNumber:self];
}

/**
 * \param type 有效值仅为 1 和 2，分别对应内部的 formatter 1 和 2
 */
- (NSString *)QNKMBStringWithType:(int)type
{
    NSAssert((1 == type || 2 == type), @"type 有效值仅为 1 和 2");
    
    int64_t value = [self longLongValue];
    
    NSUInteger index = 0;
    double dvalue = (double)value;
    
    static NSArray *s_KMBSuffix = nil;
    static uint64_t *s_KMBSuffixUnit = NULL;
    
    // 初始化中文数字显示配置
    if (!s_KMBSuffix)
    {
        s_KMBSuffix = @[ @"", @"K", @"M", @"B", @"T", @"P"];
    }
    if (!s_KMBSuffixUnit)
    {
        s_KMBSuffixUnit = (uint64_t *)malloc(sizeof(uint64_t) * 6);
        s_KMBSuffixUnit[0] = 1000;
        s_KMBSuffixUnit[1] = 1000000;
        s_KMBSuffixUnit[2] = 1000000000;
        s_KMBSuffixUnit[3] = 1000000000000;
        s_KMBSuffixUnit[4] = 1000000000000000;
        s_KMBSuffixUnit[5] = 1000000000000000000;
    }
    int i = 0;
    while (i < 6)
    {
        if (ABS(value) < s_KMBSuffixUnit[i])
        {
            index = i;
            if (index > 0)
            {
                dvalue /= s_KMBSuffixUnit[index - 1];
            }
            break;
        }
        i++;
    }
    
    static NSNumberFormatter *formatterOneFraction = nil;
    static NSNumberFormatter *formatterTwoFraction = nil;
    if (formatterOneFraction == nil || formatterTwoFraction == nil)
    {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            
            formatterOneFraction = [[NSNumberFormatter alloc] init];
            [formatterOneFraction setMinimumIntegerDigits:1];
            // 最大的有效数字的个数，如 134.55 显示为 134.6， 如 1.3455 显示为 1.346
            [formatterOneFraction setUsesSignificantDigits:YES];
            [formatterOneFraction setMaximumSignificantDigits:4];
            [formatterOneFraction setMinimumFractionDigits:0];
            [formatterOneFraction setMaximumFractionDigits:2];
            
            formatterTwoFraction = [[NSNumberFormatter alloc] init];
            [formatterTwoFraction setMinimumIntegerDigits:1];
            // 最大的有效数字的个数，如 134.55 显示为 135，如 1.3455 显示为 1.35
            [formatterTwoFraction setUsesSignificantDigits:YES];
            [formatterTwoFraction setMaximumSignificantDigits:3];
            [formatterTwoFraction setMinimumFractionDigits:0];
            [formatterTwoFraction setMaximumFractionDigits:2];
        });
    }
    
    NSNumberFormatter *formater = nil;
    if (type == 1)
    {
        formater = formatterOneFraction;
    }
    else
    {
        formater = formatterTwoFraction;
    }
    
    if (0 == value)
    {
        return @"0";
    }
    return [NSString stringWithFormat:@"%@%@", [formater stringFromNumber:@(dvalue)], s_KMBSuffix[index]];
}

- (NSString *)QNKMBString
{
    return [self QNKMBStringWithType:1];
}

- (NSString *)QNKMBStringWithThreeMaxSignificantDigits
{
    return [self QNKMBStringWithType:2];
}

static NSArray *s_aryChineseUnitString =  nil;
static NSArray *s_aryChineseFractionFormat =  nil;

// 初始化中文数字显示配置
#define FL_NUMBER_INIT_CHINESE_UNIT \
if (!s_aryChineseUnitString) \
{ \
    s_aryChineseUnitString = @[CustomLocalizedString(@"QBAI", nil), CustomLocalizedString(@"QWANG", nil), \
                        CustomLocalizedString(@"QBAIWANG", nil), CustomLocalizedString(@"QYI", nil), \
                        CustomLocalizedString(@"QWANGYI", nil)]; \
} \
if (!s_aryChineseFractionFormat) \
{ \
    s_aryChineseFractionFormat = @[@"%.0f", @"%.1f", @"%.2f", @"%.3f"]; \
}


// 更新中文显示单位
#define FL_NUMBER_UPDATE_CHINESE_UNIT \
if (value < 10000) \
{ \
    unit = 1; \
} \
else if (value < 100000000) \
{ \
    unit = 10000; \
} \
else if (value < 1000000000000) \
{ \
    unit = 100000000; \
} \
else \
{ \
    unit = 1000000000000; \
}

// 更新中文显示单位的字符串
#define FL_NUMBER_UPDATE_CHINESE_STRING \
switch (unit) \
{ \
    case 100: \
        strUnit = s_aryChineseUnitString[0]; \
        break; \
    case 10000: \
        strUnit = s_aryChineseUnitString[1]; \
        break; \
    case 1000000: \
        strUnit = s_aryChineseUnitString[2]; \
        break; \
    case 100000000: \
        strUnit = s_aryChineseUnitString[3]; \
        break; \
    case 1000000000000: \
        strUnit = s_aryChineseUnitString[4]; \
        break; \
    default: \
        break; \
}

// 更新中文显示单位及字符串
#define FL_NUMBER_UPDATE_CHINESE_UNIT_AND_STRING \
if (value < 10000) \
{ \
    unit = 1; \
} \
else if (value < 100000000) \
{ \
    unit = 10000; \
    strUnit = s_aryChineseUnitString[1]; \
} \
else if (value < 1000000000000) \
{ \
    unit = 100000000; \
    strUnit = s_aryChineseUnitString[3]; \
} \
else \
{ \
    unit = 1000000000000; \
    strUnit = s_aryChineseUnitString[4]; \
}


- (NSString *)QNChineseString
{
    FL_NUMBER_INIT_CHINESE_UNIT
    
    uint64_t value = [self longLongValue];
    
    // 确定单位
    uint64_t unit = 1;
    NSString *strUnit = @"";
    FL_NUMBER_UPDATE_CHINESE_UNIT_AND_STRING
    
    // 确定小数点的位数
    int fractionCount = 3;
    if (1 == unit)
    {
        fractionCount = 0;
    }
    else
    {
        uint64_t remain = value % unit;
        if (0 == remain)
        {
            fractionCount = 0;
        }
        uint64_t aUnit = unit / 10;
        if (remain / aUnit > 0)
        {
            fractionCount = 1;
        }
        remain %= aUnit;
        aUnit /= 10;
        if (remain / aUnit > 0)
        {
            fractionCount = 2;
        }
        remain %= aUnit;
        aUnit /= 10;
        if (remain / aUnit > 0)
        {
            fractionCount = 3;
        }
        
        if (value > (1000 * unit) && fractionCount > 2)
        fractionCount = 2;
    }
    NSString *strValue = [NSString stringWithFormat:s_aryChineseFractionFormat[fractionCount], ((double)value) / unit];
    return [NSString stringWithFormat:@"%@%@", strValue, strUnit];
}

- (NSString *)QNChineseStringWithFraction:(int)fractionCount
{
    FL_NUMBER_INIT_CHINESE_UNIT
    
    double value = [self doubleValue];
    
    // 确定单位
    uint64_t unit = 1;
    NSString *strUnit = @"";
    FL_NUMBER_UPDATE_CHINESE_UNIT_AND_STRING
    
    NSString *strValue = [NSString stringWithFormat:s_aryChineseFractionFormat[fractionCount], ((double)value) / unit];
    return [NSString stringWithFormat:@"%@%@", strValue, strUnit];
}

- (NSString *)QNChineseStringWithoutFraction
{
    FL_NUMBER_INIT_CHINESE_UNIT
    
    uint64_t value = [self longLongValue];
    
    // 确定单位
    uint64_t unit = 1;
    NSString *strUnit = @"";
    FL_NUMBER_UPDATE_CHINESE_UNIT_AND_STRING
    
    // 确定小数点的位数
    int fractionCount = 0;
    NSString *strValue = [NSString stringWithFormat:s_aryChineseFractionFormat[fractionCount], ((double)value) / unit];
    return [NSString stringWithFormat:@"%@%@", strValue, strUnit];
}

//-------------------------------------------------------------------------
// 百位计数法

+ (uint64_t)QNHundredUnitForValue:(uint64_t)value
{
    uint64_t unit = 1;
    FL_NUMBER_UPDATE_CHINESE_UNIT
    return unit;
}

+ (NSString *)QNHundredUnitStringForUnit:(uint64_t)unit
{
    FL_NUMBER_INIT_CHINESE_UNIT
    
    NSString *strUnit = @"";
    FL_NUMBER_UPDATE_CHINESE_STRING
    
    return strUnit;
}


// fractionCount: valid value: 0, 1, 2, 3
// unit: valid value: 0, 100, 10000, 1000000, 100000000
+ (NSString *)QNHundredUnitStringForValue:(uint64_t)value unit:(uint64_t)unit fractionCount:(int)fractionCount
{
    FL_NUMBER_INIT_CHINESE_UNIT
    
    if (0 == unit)
    unit = [NSNumber QNHundredUnitForValue:value];
    
    fractionCount = MAX(fractionCount, 0);
    fractionCount = MIN(fractionCount, 3);
    
    return [NSString stringWithFormat:s_aryChineseFractionFormat[fractionCount], (double)(value / unit)];
}
//---------------------------------------------------------------------------


- (NSString *)QNPriceDisplayString
{
    float price = [self floatValue];
    if (price == DEFAULT_DOUBLEVALUE) {
        return @"--";
    }
    return [NSString stringWithFormat:@"%.2f", price];
}

// fractionCount valid value is 0, 1, 2, 3.
- (NSString *)QNPriceDisplayStringWithFractionCount:(int)fractionCount
{
    int64_t price = [self longLongValue];
    if (0 == fractionCount)
    {
        return [NSString stringWithFormat:@"%lld", price / 1000];
    }
    NSString *fraction = [NSString stringWithFormat: ((3 == fractionCount) ? @"%.3f" : ((2 == fractionCount) ? @"%.2f" : @"%.1f")),
                          price % 1000 / 1000.0];
    return [NSString stringWithFormat:@"%llu.%@", price / 1000, [fraction substringFromIndex:2]];
}

- (NSString *)QNFitPriceStepString
{
    static NSNumberFormatter *formatter = nil;
    if (nil == formatter) {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            [formatter setUsesGroupingSeparator: NO];
            [formatter setMinimumIntegerDigits: 1];
        });
    }
    int64_t price = [self longLongValue];
    
    NSInteger fraction = 3; // 产品童鞋要求统一为3位小数
//    if (price / 1000 > 10) {
//        fraction = 2;
//    }
    [formatter setMinimumFractionDigits: fraction];
    [formatter setMaximumFractionDigits: fraction];
    return [formatter stringFromNumber: @(price / 1000.f)];
}

- (NSString *)QNFiveZeroFiveFractionString
{
    return [NSString stringWithFormat:@"%.5f", self.longLongValue / 100000.0];
}

- (NSString *)QNFiveZeroThreeFractionString
{
    return [NSString stringWithFormat:@"%.3f", self.longLongValue / 100000.0];
}

- (NSString *)QNFiveZeroAutoFractionString
{
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil)
    {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            [formatter setUsesGroupingSeparator:NO];
            [formatter setMinimumFractionDigits:0];
            [formatter setMaximumFractionDigits:5];
            [formatter setMinimumIntegerDigits:1];
        });
    }
    double value = [self longLongValue] / 100000.0;
    return [formatter stringFromNumber:@(value)];
}

// 最少小数位为2位
- (NSString *)QNFiveZeroMiniTwoFractionString
{
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil)
    {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            [formatter setGroupingSize:3];
            [formatter setGroupingSeparator:@","];
            [formatter setUsesGroupingSeparator:YES];
            [formatter setMinimumFractionDigits:2];
            [formatter setMaximumFractionDigits:5];
            [formatter setMinimumIntegerDigits:1];
        });
    }
    double value = [self longLongValue] / 100000.0;
    return [formatter stringFromNumber:@(value)];
}

- (NSString *)QNFiveZeroMinimalFractionString
{
    return [self QNFiveZeroAutoFractionString];
}


- (NSString *)QNFiveZeroMoneyString
{
    return [self QNFiveZeroMiniTwoFractionString];
}

- (NSString *)QNFiveZeroKMBString
{
    int64_t value = self.longLongValue;
    return [@(value / 100000) QNKMBString];
}

- (NSString *)QNFiveZeroOneFractionString
{
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil)
    {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            [formatter setGroupingSize:3];
            [formatter setGroupingSeparator:@","];
            [formatter setUsesGroupingSeparator:YES];
            [formatter setMinimumFractionDigits:1];
            [formatter setMaximumFractionDigits:1];
            [formatter setMinimumIntegerDigits:1];
        });
    }
    double value = [self longLongValue] / 100000.0;
    return [formatter stringFromNumber:@(value)];
}


- (NSString *)QNFiveZeroSignedMoneyString
{
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil)
    {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            [formatter setGroupingSize:3];
            [formatter setGroupingSeparator:@","];
            [formatter setUsesGroupingSeparator:YES];
            [formatter setMinimumFractionDigits:2];
            [formatter setMaximumFractionDigits:5];
            [formatter setMinimumIntegerDigits:1];
            [formatter setPositivePrefix: @"+"];
        });
    }
    double value = [self longLongValue] / 100000.0;
    return [formatter stringFromNumber:@(value)];
}

- (NSString *)QNThreeDotFractionString
{
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil)
    {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            [formatter setGroupingSize:3];
            [formatter setGroupingSeparator:@","];
            [formatter setUsesGroupingSeparator:YES];
            [formatter setMinimumFractionDigits:2];
            [formatter setMaximumFractionDigits:2];
            [formatter setMinimumIntegerDigits:1];
        });
    }
    double value = [self doubleValue];
    return [formatter stringFromNumber:@(value)];
}

@end









