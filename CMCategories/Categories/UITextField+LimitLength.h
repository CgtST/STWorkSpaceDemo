//
//  UITextField+LimitLength.h
//  APlan
//
//  Created by he15his on 14-9-15.
//  Copyright (c) 2014年 jingling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LimitLength)
/**
 *  使用时只要调用此方法，加上一个长度(int)，就可以实现了字数限制
 *
 *  @param length 限制长度
 *  @param number 中文相当的字符数
 */
- (void)limitTextLength:(NSInteger)length numberOfChineseChar:(NSInteger)number;

/**
 *  限制文字字数
 *
 *  @param length      字数
 *  @param changeBlock 文本改变时的回调方法
 */
- (void)limitTextLength:(NSInteger)length textFieldChangeBlock:(void(^)(void))changeBlock numberOfChineseChar:(NSInteger)number;

/**
 *  uitextField 抖动效果
 */
- (void)shake;
@end
