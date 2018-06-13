//
//  CDTDatatTrans.h
//  CommonDataTools
//
//  Created by bingo on 16/12/23.
//  Copyright © 2016年 zscf. All rights reserved.
//

#import <Foundation/Foundation.h>

//数据转换
@interface CTDatatTrans : NSObject

+(nullable NSDictionary*)data2Dictionary:(nonnull NSData*)data;

+(nonnull NSString*)data2NSString:(nonnull NSData*)data;

+(nullable NSData*)dictionary2Data:(nonnull NSDictionary*)dic;

+(nullable NSString*)dictionary2Str:(nonnull NSDictionary*)dic;

+(nonnull NSString*)array2NSString:(nonnull NSArray<__kindof NSDictionary*>*)arr;

+(nullable NSArray<__kindof NSDictionary*>*)str2Array:(nonnull NSString*)str;

@end
