//
//  CDTDatatTrans.m
//  CommonDataTools
//
//  Created by bingo on 16/12/23.
//  Copyright © 2016年 zscf. All rights reserved.
//

#import "CTDatatTrans.h"

@implementation CTDatatTrans

+(nullable NSDictionary*)data2Dictionary:(nonnull NSData*)data
{
    NSError *parseError = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
    if(dic.count > 0 && nil == parseError)
    {
        return dic;
    }
    return nil;
}

+(nullable NSData*)dictionary2Data:(nonnull NSDictionary*)dic
{
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    if(data.length > 0 && nil == parseError)
    {
        return data;
    }
    return nil;
}

+(nonnull NSString*)data2NSString:(nonnull NSData*)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


+(nullable NSString*)dictionary2Str:(nonnull NSDictionary*)dic
{
    NSData *data = [[self class] dictionary2Data:dic];
    if(nil == data)
    {
        return nil;
    }
    return [[self class] data2NSString:data];
}

+(nonnull NSString*)array2NSString:(nonnull NSArray<__kindof NSDictionary*>*)arr
{
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if(nil == parseError)
    {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
    
}

+(nullable NSArray<__kindof NSDictionary*>*)str2Array:(nonnull NSString*)str
{
    NSError * parseError = nil;
    NSArray * arr = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&parseError];
    if(nil == parseError)
    {
        return arr;
    }
    return nil;
}


@end
