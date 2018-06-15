//
//  CDTFontTools.h
//  CommonDataTools
//
//  Created by bingo on 16/10/18.
//  Copyright © 2016年 CM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTFontTools : NSObject

+(CGFloat)getHeightOfFont:(nonnull UIFont*)font;

//无换行
+(CGSize)getFontSizeOfStr:(nonnull NSString*)str Font:(nonnull UIFont*)font;

+(CGFloat)getHeightOfStr:(nonnull NSString*)str Font:(nonnull UIFont*)font Width:(CGFloat)fWidth;

//获取固定宽度内字体的实际大小(一个汉字并且使用系统默认字体)
+(CGFloat)getFontSizeForWidth:(CGFloat)width;

@end
