//
//  CDTImageTools.h
//  CommonDataTools
//
//  Created by bingo on 16/10/18.
//  Copyright © 2016年 zscf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//图片的操作
@interface CTImageTools : NSObject

//将颜色转换为图片
+(nonnull UIImage*)color2imageWithFrame:(CGRect)rect Color:(nonnull UIColor*)color;

//修改图片大小
+(nonnull UIImage*)modifyImageSize:(CGSize)size OfImage:(nonnull UIImage*)image;

//图片圆形化
+(nonnull UIImage*)circleImageSourceImge:(nonnull UIImage *)sourceImage borderWidth:(float)borderWidth borderColor:(nullable UIColor*)color;

//获取mainbundle下的图片,图片格式为png
+(nullable UIImage*)getImageByName:(nonnull NSString*)imageName;

//获取图片,bundlename为nil时表示从mainbundle中获取图片,图片格式为png
+(nullable UIImage*)getImageByName:(nonnull NSString*)imageName bundleName:(nullable NSString*)bundlename;

//获取图片
+(nullable UIImage*)getImageByName:(nonnull NSString*)imageName bundleName:(nullable NSString*)bundlename inDirectory:(nullable NSString*)directory;

@end
