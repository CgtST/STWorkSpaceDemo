//
//  CMDataEncryAndDecry.h
//  CMTools
//
//  Created by bingo on 2018/6/13.
//  Copyright © 2018年 bingo. All rights reserved.
//


/*
 data 数据加密与解密类
 */


#import <Foundation/Foundation.h>

@interface CTDataEncryAndDecry : NSObject


//base64加密
+( NSData*)encryWithbase64:( NSData*)orgData;

//base64解密
+( NSData*)decryWithbase64:( NSData*)orgData;

//MD5加密,加密后的字符串为大写
+( NSString*)decryWithMD5:( NSString*)str;

//SHA加密,加密后的字符串为大写
+( NSString*)decryWithSHA:( NSString*)str;


@end
