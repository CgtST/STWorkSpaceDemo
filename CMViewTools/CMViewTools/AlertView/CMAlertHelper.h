//
//  CMAlertHelper.h
  
//
//  Created by bingo on 15/11/10.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

#define K_AlertView_Width  (ceil([UIScreen mainScreen].bounds.size.width * 0.85))   //弹框宽度
#define K_MaxAlertView_Height  (ceil([UIScreen mainScreen].bounds.size.height * 0.7))  //弹框最大高度

@interface CMAlertHelper : NSObject

#pragma mark - 展示视图

+(void)showView:(nonnull UIView *)alertView DelayTime:(NSTimeInterval)delayTime;

+(void)showView:(nonnull UIView *)alertView DelayTime:(NSTimeInterval)delayTime isLandscape:(BOOL)bLandscape;

+(void)showViewWithoutDismiss:(nonnull UIView*)alertView;  //视图默认不消失

+(void)showLandscapeViewWithoutDismiss:(nonnull UIView*)alertView; //横屏显示,视图不消失

+(void)showViewWithoutDismiss:(nonnull UIView *)alertView startPt:(CGPoint)startPt;

+(void)showLandscapeViewWithoutDismiss:(nonnull UIView*)alertView startPt:(CGPoint)startPt; //横屏显示,视图不消失

+(void)dismissView;  //销毁视图

#pragma mark - 修改展示视图的属性

+(void)moveAlertViewCenter:(CGPoint)centerpt Animation:(BOOL)bani; //移动视图的中心点

+(void)resetAlertViewToCenterAnimation:(BOOL)bani; //将弹窗视图移动到中心位置

+(CGPoint)getAlertViewCenter;

+(void)setAlertViewBackGroundColor:(nonnull UIColor*)bgColor;

+(void)setAlertDissmissWhenTapBlank; //设置点击空白处时，弹窗视图消失

#pragma mark - 通过present展示视图

+(void)presentAlertController:(nonnull UIViewController*)alertController ByController:(nonnull UIViewController*)baseController;

@end
