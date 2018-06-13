//
//  CDTImageTools.m
//  CommonDataTools
//
//  Created by bingo on 16/10/18.
//  Copyright © 2016年 zscf. All rights reserved.
//

#import "CTImageTools.h"

@implementation CTImageTools

+(nonnull UIImage*)color2imageWithFrame:(CGRect)rect Color:(nonnull UIColor*)color
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(nonnull UIImage*)modifyImageSize:(CGSize)size OfImage:(nonnull UIImage*)image
{
    if(CGSizeEqualToSize(image.size, size))
    {
        return image;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//图片圆形化
+(nonnull UIImage*)circleImageSourceImge:(nonnull UIImage *)sourceImage borderWidth:(float)borderWidth borderColor:(nullable UIColor*)borderColor
{
    CGFloat imageW = sourceImage.size.width + 2 * borderWidth;
    CGFloat imageH = imageW;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(context);
    
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//获取mainbundle下的图片,图片格式为png
+(nullable UIImage*)getImageByName:(nonnull NSString*)imageName
{
    return [[self class] getImageByName:imageName bundleName:nil];
}

//获取图片,bundlename为nil时表示从mainbundle中获取图片
+(nullable UIImage*)getImageByName:(nonnull NSString*)imageName bundleName:(nullable NSString*)bundlename
{
    return [[self class] getImageByName:imageName bundleName:bundlename inDirectory:nil];
}

//获取图片
+(nullable UIImage*)getImageByName:(nonnull NSString*)imageName bundleName:(nullable NSString*)bundlename inDirectory:(nullable NSString*)directory
{
    NSBundle *bundle = nil;
    if(nil != bundlename)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:bundlename ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    }
    if(nil == bundle)
    {
        bundle = [NSBundle mainBundle];
    }
    
    NSString *path = [bundle pathForResource:imageName ofType:@"png" inDirectory:directory];
    NSString *path2x = [bundle pathForResource:[NSString stringWithFormat:@"%@@2x",imageName] ofType:@"png" inDirectory:directory];
    NSString *path3x = [bundle pathForResource:[NSString stringWithFormat:@"%@@3x",imageName] ofType:@"png" inDirectory:directory];
    NSArray *pathArr = @[];
    if(3 == [UIScreen mainScreen].scale) //3x下优先获取高清图片
    {
        NSMutableArray *arr = [NSMutableArray array];
        if(nil != path3x)
        {
            [arr addObject:path3x];
        }
        if(nil != path2x)
        {
            [arr addObject:path2x];
        }
        if(nil != path)
        {
            [arr addObject:path];
        }
        pathArr = [arr copy];
    }
    else if(2 == [UIScreen mainScreen].scale)
    {
        NSMutableArray *arr = [NSMutableArray array];
        if(nil != path2x)
        {
            [arr addObject:path2x];
        }
        if(nil != path3x)
        {
            [arr addObject:path3x];
        }
        if(nil != path)
        {
            [arr addObject:path];
        }
        pathArr = [arr copy];
    }
    else
    {
        NSMutableArray *arr = [NSMutableArray array];
        if(nil != path)
        {
            [arr addObject:path];
        }
        if(nil != path2x)
        {
            [arr addObject:path2x];
        }
        if(nil != path3x)
        {
            [arr addObject:path3x];
        }
        pathArr = [arr copy];
    }
    
    for(NSString *imagePath in pathArr)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if(nil != image)
        {
            return image;
        }
    }
    return nil;

}

@end
