//
//  CDTNumberTools.m
//  CommonDataTools
//
//  Created by bingo on 16/10/18.
//  Copyright © 2016年 CM. All rights reserved.
//

#import "CTNumberTools.h"

@implementation CTNumberTools

#pragma mark - 小数精度

//判断小数是几位
+(NSInteger)getDoubleDec:(double)dValue
{
    NSString *valueStr = [[self class] double2NStringTrimO: dValue withDec:14];
    NSInteger len = valueStr.length;
    NSRange range = [valueStr rangeOfString:@"."];
    if (range.length == 0)
    {
        return 0;
    }
    return len - (range.location+1);
}

+(NSUInteger)decOfValueTrim0:(nonnull NSString*)valueStr
{
    if(0 == valueStr.length)
    {
        return 0;
    }
    NSRange range = [valueStr rangeOfString:@"."]; //找小数点的位置
    if(range.length >0)
    {
        NSString *value = [NSString stringWithString:valueStr];
        //去掉末尾的0
        while (true)
        {
            unichar cha = [value characterAtIndex:value.length - 1];
            if('0' != cha)
            {
                break;
            }
            value = [value substringToIndex:value.length - 1];
        }
        return value.length - range.location - 1;
    }
    return 0;
    
}

//double转换为字符串(正值为:"2.50",负值为"-2.50")
+(nonnull NSString*)double2NString:(double)dValue withDec:(NSUInteger)idec
{
    //对O值的处理
    if(YES == [[self class] isEqualToZero:dValue])
    {
        NSString *retStr = (0 == idec) ? @"0" : @"0.";
        for(NSUInteger i = 0 ; i< idec ; ++ i)
        {
            retStr = [NSString stringWithFormat:@"%@0",retStr];
        }
        return retStr;
    }
    NSString *formate = [NSString stringWithFormat:@"%%.%ldf",(long)idec];
    NSString *retStr = [NSString stringWithFormat:formate,dValue];
    //去掉-0或者-0.0等前面的负号
    if(YES == [[self class] isEqualToZero:[retStr doubleValue]])
    {
        retStr = [retStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return retStr;
}

// 1.235 ->1.24    1.000 -> 1
+(nonnull NSString*)double2NStringTrimO:(double)dValue withDec:(NSUInteger)idec
{
    NSDecimalNumberHandler *numberHandle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:idec raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *inNumber = [[NSDecimalNumber alloc] initWithFloat:dValue];
    NSDecimalNumber *formatNumber = [inNumber decimalNumberByRoundingAccordingToBehavior:numberHandle];
    return  [NSString stringWithFormat:@"%@",formatNumber];
}

#pragma mark - 缩写

//double转换为字符串，字符串中使用"亿"，"万"缩写
+(nonnull NSString*)double2NumWithUnit:(double)dValue
{
    long unit = [[self class] getValueUnit:dValue];
    double bmkValue = dValue;
    if(0 != unit)
    {
        bmkValue = dValue / unit;
    }
    NSString *str = [[self class] double2NStringTrimO:bmkValue withDec:2];
    return [NSString stringWithFormat:@"%@%@",str,[[self class] getStringUnit:dValue]];
}

//获取值的缩放单位
+(long)getValueUnit:(double)dValue
{
    long unit = 1;
    if(dValue <= -1e8 || dValue >= 1e8)  //亿
    {
        unit = 1e8;
    }
    else if(dValue <= -1e4 || dValue >= 1e4)  //万
    {
        unit =  1e4;
    }
    return unit;
}

//获取缩放单位对应得字符串
+(nonnull NSString*)getStringUnit:(double)dValue
{
    NSString *unitStr = @"";
    if(dValue <= -1e8 || dValue >= 1e8)  //亿
    {
        unitStr = @"亿";
    }
    else if(dValue <= -1e4 || dValue >= 1e4)  //万
    {
        unitStr = @"万";
    }
    return unitStr;
}

#pragma mark - 与0相等

//是否与0值相等
+(BOOL)isEqualToZero:(double)dValue;  //(9位精度)
{
    if (dValue > -0.000000001 && dValue < 0.000000001)  //9位小数的比较
    {
        return YES;
    }
    return NO;
}

+(BOOL)isFloatEqualToZero:(float)fValue  //（5位精度)
{
    if (fValue > -0.00001 && fValue < 0.00001)  //5位小数的比较
    {
        return YES;
    }
    return NO;
}

#pragma mark - 数值查找

+(BOOL)isNumber:(nonnull NSNumber*)curNum inArr:(nonnull NSArray<__kindof NSNumber*>*)numArr
{
    NSInteger index = [[self class] getIndex:curNum inArr:numArr];
    return NSNotFound != index;
}

+(NSInteger)getIndex:(nonnull NSNumber*)curNum inArr:(nonnull NSArray<__kindof NSNumber*>*)numArr
{
    for(NSUInteger i=0;i<numArr.count;i++)
    {
        NSNumber *num = [numArr objectAtIndex:i];
        if(YES == [num isEqualToNumber:curNum])
        {
            return i;
        }
    }
    return NSNotFound;
}



//去掉浮点数后面多余的0
+(NSString*)removeFloatAllZero:(NSString*)string
{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}



+(NSString *)changeStringWithId:(id)value
{
    NSString * temp = @"";
    if ([value isKindOfClass:[NSString class]]) {
        if ([(NSString *)value length]>0) {
            temp = value;
        }
    }
    else if([value isKindOfClass:[NSNull class]]  ) {
        return @"";
    }else  {
        temp = [value stringValue];
    }
    
    if (temp.length == 0) {
        temp = @"--";
    }
    return temp;
}


@end
