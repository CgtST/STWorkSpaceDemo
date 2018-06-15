//
//  CMAlertHelper.m
  
//
//  Created by bingo on 15/11/10.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMAlertHelper.h"
#import "CMAlertWindow.h"


#define g_AlertNotDissTime  100000


@implementation CMAlertHelper

#pragma mark - 展示视图

+(void)showView:(nonnull UIView *)alertView DelayTime:(NSTimeInterval)delayTime
{
    [CMAlertHelper showView:alertView DelayTime:delayTime isLandscape:NO];
}

+(void)showView:(nonnull UIView *)alertView DelayTime:(NSTimeInterval)delayTime isLandscape:(BOOL)bLandscape
{
    CMAlertWindow *alertWindow = [CMAlertWindow shared];
    if(YES == alertWindow.hadAlert) //已经弹窗了
    {
        return;
    }
    alertWindow.delayTime = delayTime;
    alertWindow.bLandscape = bLandscape;
    
   
    
    [alertWindow addSubview:alertView];
}


+(void)showViewWithoutDismiss:(nonnull UIView*)alertView
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.duration = 0.2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.values = @[@(1.01), @(1.02), @(1.03), @(1.04), @(1.03),@(1.02), @(1.01), @(1), @(1.01), @(1)];
    [alertView.layer addAnimation:animation forKey:@"beginaniamtion"];
    [CMAlertHelper showView:alertView DelayTime:g_AlertNotDissTime isLandscape:NO];
}
+(void)showLandscapeViewWithoutDismiss:(nonnull UIView*)alertView //横屏显示
{
    CMAlertWindow *alertWindow = [CMAlertWindow shared];
    if(YES == alertWindow.hadAlert) //已经弹窗了
    {
        return;
    }
    alertWindow.delayTime = g_AlertNotDissTime;
    alertWindow.bLandscape = YES;
    [alertWindow addSubview:alertView];

}

+(void)showViewWithoutDismiss:(nonnull UIView *)alertView startPt:(CGPoint)startPt
{
    CGRect bounds = alertView.bounds;
    CGPoint center = CGPointMake(startPt.x + bounds.size.width/2, startPt.y + bounds.size.height/2); //导航栏高度
    CMAlertWindow *alertWindow = [CMAlertWindow shared];
    if(alertWindow.hadAlert) //已经弹窗了
    {
        return;
    }
    [alertWindow setDismissWhenTap];
    alertWindow.delayTime = g_AlertNotDissTime;
    [alertWindow modifyCenter:center Animation:NO];
    [alertWindow addSubview:alertView];
}

+(void)showLandscapeViewWithoutDismiss:(nonnull UIView*)alertView startPt:(CGPoint)startPt //横屏显示,视图不消失
{
    CGRect bounds = alertView.bounds;
    CGPoint center = CGPointMake(startPt.x - bounds.size.height/2, startPt.y + bounds.size.width/2); //导航栏高度
    CMAlertWindow *alertWindow = [CMAlertWindow shared];
    if(YES == alertWindow.hadAlert) //已经弹窗了
    {
        return;
    }
    alertWindow.delayTime = g_AlertNotDissTime;
    alertWindow.bLandscape = YES;
    [alertWindow modifyCenter:center Animation:NO];
    [alertWindow addSubview:alertView];
}

+(void)dismissView  //销毁视图
{
     [[CMAlertWindow shared] dismissView];
}

#pragma mark - 修改展示视图的属性

+(void)moveAlertViewCenter:(CGPoint)centerpt Animation:(BOOL)bani //移动视图的中心点
{
    if(YES == [CMAlertWindow shared].hadAlert)
    {
        [[CMAlertWindow shared] modifyCenter:centerpt Animation:YES];
    }
}

+(void)resetAlertViewToCenterAnimation:(BOOL)bani //将弹窗视图移动到中心位置
{
    if(YES == [CMAlertWindow shared].hadAlert)
    {
        CMAlertWindow *alsertWindow = [CMAlertWindow shared];
        [alsertWindow modifyCenter:alsertWindow.center Animation:bani];
    }
}

+(CGPoint)getAlertViewCenter
{
    return [[CMAlertWindow shared] getAlertCenter];
}

+(void)setAlertViewBackGroundColor:(nonnull UIColor*)bgColor
{
    [CMAlertWindow shared].alertMaskColor = bgColor;
    [CMAlertWindow shared].backgroundColor = bgColor;
}


+(void)setAlertDissmissWhenTapBlank //设置点击空白处时，弹窗视图消失
{
     [[CMAlertWindow shared] setDismissWhenTap];
}

#pragma mark - 通过present展示视图

+(void)presentAlertController:(nonnull UIViewController*)alertController ByController:(nonnull UIViewController*)baseController
{
    if(YES == [alertController isKindOfClass:[UIAlertController class]])
    {
        [baseController presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)
        {
            alertController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        else
        {
            baseController.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
        [baseController presentViewController:alertController animated:NO completion:^
         {
             alertController.view.superview.backgroundColor = [UIColor clearColor];
         }];
    }
}

@end
