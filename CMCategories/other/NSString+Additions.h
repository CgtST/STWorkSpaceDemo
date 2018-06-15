//
//  NSString+Additions.h
//  FutuLogic
//
//  Created by manny on 12-11-26.
//  Copyright (c) 2012年 Futu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+ (NSString *)hexStringWithData:(unsigned char*)data length:(NSUInteger)length;
+ (NSString *)base64StringWithData:(unsigned char*)data length:(int)length;
- (NSString *)md5String;
- (int64_t)QNFiveZeroNumber;
+ (NSString*)codeFromAccessId:(NSString*)accessId;
/**
 *  把文本中重复的回车内容替换成单个回车
 *
 *  @return 返回替换之后的文本，如果替换不成功，则返回原文本
 */
- (NSString *)stringByTrimmingRepeatedNewlines;

@end


