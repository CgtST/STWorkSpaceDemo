//
//  CTAnimationTools.h
//  CMTools
//
//  Created by bingo on 2018/6/13.
//  Copyright © 2018年 bingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>


@interface CTAnimationTools : NSObject
/**
 创建一个变大的scale动画
 
 @return 返回这个动画
 */
+ (CAKeyframeAnimation *)getBigKeyScaleAnimation;




/**
 获取一个旋转的动画----逆时针
 
 @return 返回这个动画
 */
+ (CABasicAnimation *)getRotateAnimation;



/**
 获取一个旋转的动画----逆时针
 
 @param time 动画时间
 @return 返回这个动画
 */
+ (CABasicAnimation *)getRotateAnimationWithTime:(double)time;



/**
 创建一个变小的scale动画
 
 @return 返回这个动画
 */
+ (CAKeyframeAnimation *)getSmallKeyScaleAnimation;
@end
