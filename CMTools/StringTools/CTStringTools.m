//
//  CDTStringTools.m
//  CommonDataTools
//
//  Created by bingo on 16/10/18.
//  Copyright © 2016年 CM. All rights reserved.
//

#import "CTStringTools.h"

@implementation CTStringTools

+(BOOL) isNSStringEmptyOrNil:(nullable NSString*)nStr
{
    NSString *myStr = [[self class] trim:nStr];
    return (nil == myStr || 0 == myStr.length) ? YES : NO;
}

+(nullable NSString*) trim:(nullable NSString*)nStr
{
    if(nil == nStr)
    {
        return nil;
    }
    return [nStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)string:(nullable NSString*)nStr containsString:(nullable NSString *)subString
{
    if(nil == nStr)
    {
        return NO;
    }
    if(nil == subString)
    {
        return YES;
    }
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        NSRange range = [nStr rangeOfString:subString];
        if(range.length > 0)
        {
            return YES;
        }
        return NO;
    }
    return [nStr containsString:subString];
}

+ (nullable ushort *)NSString2short:(nullable NSString*)str
{
    if(nil == str)
    {
        return NULL;
    }
    return (ushort*)[str cStringUsingEncoding:NSUTF16LittleEndianStringEncoding];
}

+ (nullable NSString*)ushort2NString:(nullable const ushort *)strUshort
{
    if (NULL == strUshort)
    {
        return  nil;
    }
    NSInteger len = [[self class] getBytesLength:strUshort];
    NSString *str = [[NSString alloc] initWithBytes:(void*)strUshort length:len encoding:NSUTF16LittleEndianStringEncoding];
    return str;
}

+(NSUInteger)getBytesLength:(nullable const ushort *)pszStr
{
    if (NULL == pszStr)
    {
        return  0;
    }
    NSInteger iLen = 0;
    while(*pszStr != 0)
    {
        ++iLen;
        ++pszStr;
    }
    return iLen * sizeof(ushort);
}


#pragma mark - 验证

+ (BOOL)regexMatch:(nonnull NSString *)sourceText withRegex:(nonnull NSString *)regexPattern
{
    if(0 == sourceText.length)
    {
        return NO;
    }
    NSError *matchError = nil;
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:regexPattern
                                                                                     options:0
                                                                                       error:&matchError];
    const NSUInteger matchCount = [regexExpression numberOfMatchesInString:sourceText
                                                                   options:0
                                                                     range:NSMakeRange(0, [sourceText length])];
    return 0 != matchCount;
}

+(BOOL)isNumAndLetters:(nonnull NSString*)str
{
    return [[self class] regexMatch:str withRegex:@"^[A-Za-z0-9]+$"];
}

//是否为IP地址
+ (BOOL)isIpAddress:(nonnull NSString*)ipStr
{
    return [[self class] regexMatch:ipStr withRegex:@"^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})(\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})){3}$"];
}

//是否为Url
+ (BOOL)isUrl:(nonnull NSString *)urlStr
{
    return [[self class] regexMatch:urlStr withRegex:@"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"];
}

//是否为数字
+ (BOOL)isNumber:(nonnull NSString*)numStr
{
    return [[self class] regexMatch:numStr withRegex:@"^(-)?[0-9]+([.][0-9]+){0,1}$"];
}

//是否为身份证号码
+ (BOOL)isIdentityCarNum:(nonnull NSString*)carNum
{
    return [[self class] regexMatch:carNum withRegex:@"^(\\d{14}[[0-9],0-9xX]"];
}

//是否是座机号码
+ (BOOL) isTelePhoneNum:(nonnull NSString*)phoneNum
{
    return [[self class] regexMatch:phoneNum withRegex:@"^(\\d{3,4}-)\\d{7,8}$"];
}

//是否为手机号码
+ (BOOL)isMobilePhoneNum:(nonnull NSString*)phoneNum
{
    return [[self class] regexMatch:phoneNum withRegex:@"^1[3|4|5|7|8][0-9]\\d{8}$"];
}

+ (BOOL) isRegexMatchMobilePhoneNum:( NSString *)phoneNum
{
    if(0 == phoneNum.length)
    {
        return YES;
    }
    else if(1 == phoneNum.length)
    {
        return [phoneNum isEqualToString:@"1"];
    }
    else if(2==phoneNum.length)
    {
        return [[self class] regexMatch:phoneNum withRegex:@"^1[3|4|5|7|8]$"];
    }
    else if(3 == phoneNum.length)
    {
        return [[self class] regexMatch:phoneNum withRegex:@"^1[3|4|5|7|8][0-9]$"];
    }
    else if(phoneNum.length <=11)
    {
        return [[self class] regexMatch:phoneNum withRegex:@"^1[3|4|5|7|8][0-9]\\d{0,8}$"];
    }
    return NO;
}

+ (NSString*)urlEncodingWithStr:(NSString*)strUrl
{
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)strUrl,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
    
}

//提取子串
+ (nullable NSString *)getMidString:(nullable NSString*)sourceString leftString:(nullable NSString*)leftStr rightString:(nullable NSString*)rightStrig
{
    NSRange leftRange = [sourceString rangeOfString:leftStr];
    NSRange rightRange = [sourceString rangeOfString:rightStrig];
    if(leftRange.length==0||rightRange.length==0)
    {
        return nil;
    }
    
    return  [sourceString  substringWithRange: NSMakeRange(leftRange.location+leftStr.length, rightRange.location - leftRange.location-leftStr.length)];
}



#pragma mark - 转json 字符串

//json 转字符串
+ (nonnull NSString*)convertToStringJSONDict:(nonnull NSDictionary *)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    //
    //    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}



//数组转 json字符串
+(nonnull NSString *)convertToStringJSONDataFromeArray:(nonnull NSArray *)infoArray
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoArray
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    //
    //    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}

//JSON字符串转化为字典
+ (nonnull NSDictionary *)convertToDictionaryWithJsonString:(nonnull NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


//JSON字符串转化为数组
+ (nonnull NSArray  *)convertToArrayWithJsonString:(nonnull NSString *)jsonString
{
    if (jsonString == nil) {
        return  [NSArray array];
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray * arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return  [NSArray array];
    }
    return arr;
}

//判断密码是否是 6~8位字母 + 数字
+(BOOL)judgePasswordVilade:(NSString *)string
{
    NSError *matchError = nil;
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,8}$"
                                                                                     options:0
                                                                                       error:&matchError];
    const NSUInteger matchCount = [regexExpression numberOfMatchesInString:string
                                                                   options:0
                                                                     range:NSMakeRange(0, [string length])];
    return 0 != matchCount;
    
}


//判断账号是否是 5~20位的字母 + 数字
+(BOOL)judgeTradeAccountVilade:(NSString *)string{
    NSError *matchError = nil;
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{5,20}$"
                                                                                     options:0
                                                                                       error:&matchError];
    const NSUInteger matchCount = [regexExpression numberOfMatchesInString:string
                                                                   options:0
                                                                     range:NSMakeRange(0, [string length])];
    return 0 != matchCount;
}



///判断是否是纯数字
+ (BOOL)judgePureNumVilade:(NSString *)string{
    if (string == nil) {
        return NO;
    }
    if (string.length == 0) {
        return NO;
    }
    NSError *matchError = nil;
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]*$"
                                                                                     options:0
                                                                                       error:&matchError];
    const NSUInteger matchCount = [regexExpression numberOfMatchesInString:string
                                                                   options:0
                                                                     range:NSMakeRange(0, [string length])];
    return 0 != matchCount;
}



@end
