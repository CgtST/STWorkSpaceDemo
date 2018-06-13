//
//  CTAnimationTools.m
//  CMTools
//
//  Created by bingo on 2018/6/13.
//  Copyright © 2018年 bingo. All rights reserved.
//

#import "CTAnimationTools.h"

@implementation CTAnimationTools



/**
 创建一个变大的scale动画
 
 @return 返回这个动画
 */
+ (CAKeyframeAnimation *)getBigKeyScaleAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1), @(1.02), @(1.04), @(1.06), @(1.08)];
    animation.repeatCount = 1;
    animation.duration = 0.2f;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}


/**
 创建一个变小的scale动画
 
 @return 返回这个动画
 */
+ (CAKeyframeAnimation *)getSmallKeyScaleAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.98), @(0.96), @(0.94), @(0.92)];
    animation.repeatCount = 1;
    animation.duration = 0.2f;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

/**
 获取一个旋转的动画----逆时针
 
 @return 返回这个动画
 */
+ (CABasicAnimation *)getRotateAnimation {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.toValue = [NSNumber numberWithFloat:0.f];
    rotationAnimation.duration = 0.6;
    rotationAnimation.repeatCount = 1;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = YES;
    return rotationAnimation;
}



/**
 获取一个旋转的动画----逆时针
 
 @param time 动画时间
 @return 返回这个动画
 */
+ (CABasicAnimation *)getRotateAnimationWithTime:(double)time {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.toValue = [NSNumber numberWithFloat:0.f];
    rotationAnimation.duration = time;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    return rotationAnimation;
}

@end
