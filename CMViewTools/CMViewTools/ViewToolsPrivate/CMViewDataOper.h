//
//  CMViewDataOper.h
//  ViewTools
//
//  Created by bingo on 15/11/4.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//视图中用到的类型数据类
@interface CMViewDataOper : NSObject

+(CGSize)getFontSizeStr:(nonnull NSString*)str WithFont:(nonnull UIFont*)font withSize:(CGSize)size;

+(CGFloat)getFontWidthStr:(nullable NSString*)str withFont:(nullable UIFont*)font;

//获取文字高度
+(CGFloat)getHeightOfStr:(nonnull NSString*)str WithFont:(nonnull UIFont*)font andWidth:(CGFloat)fWidth;

+(CGFloat)getFontHeight:(nonnull UIFont*)font;

@end
