//
//  CMAlertWindow.m
//  ViewTools
//
//  Created by bingo on 15/11/5.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMAlertWindow.h"

@interface CMAlertWindow ()
{
    UIControl *m_contentControl;
}
@property(nonatomic) CGPoint subViewcenter;
@end

@implementation CMAlertWindow

#pragma mark - 初始化

-(instancetype)init
{
    self = [super init];
    if(nil != self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.alertMaskColor = [UIColor clearColor];
        
        m_contentControl = [[UIControl alloc] initWithFrame:self.bounds];
        m_contentControl.backgroundColor = [UIColor clearColor];
        [super addSubview:m_contentControl];
        self.subViewcenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self resetState];
    }
    return self;
}

-(void)resetState
{
    if(nil != self.superview)
    {
        [self removeFromSuperview];
    }
    self.backgroundColor = self.alertMaskColor;
    self.bLandscape = NO;
    self.opaque = NO;
    _delayTime = 20;
    self.subViewcenter = self.center;
    [m_contentControl removeTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
}

+ (nonnull instancetype)shared
{
    static dispatch_once_t once;
    static CMAlertWindow *alert = nil;
    dispatch_once(&once, ^{
        alert = [[CMAlertWindow alloc] init];
    });
    return alert;
}

#pragma mark - public

-(CGPoint)getAlertCenter
{
    return self.subViewcenter;
}

-(void)modifyCenter:(CGPoint)centerPt Animation:(BOOL)ani
{
    self.subViewcenter = centerPt;
    if(NO == ani)
    {
        for(UIView *subView in m_contentControl.subviews)
        {
            subView.center = self.subViewcenter;
        }
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^
         {
             for(UIView *subView in m_contentControl.subviews)
             {
                 subView.center = self.subViewcenter;
             }
         }];
    }
}

-(CGPoint)getSubViewCenter
{
    return self.subViewcenter;
}

-(void)dismissView
{
    for(UIView *subView in m_contentControl.subviews)
    {
        [subView removeFromSuperview];
    }
    [self resetState];
}

-(void)addSubview:(UIView *)view
{
    if(view.layer.cornerRadius < 1) //没有圆角是设置圆角
    {
        view.layer.cornerRadius = 1.5;
    }
    if(YES == self.bLandscape) //横屏
    {
        view.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    view.center = self.subViewcenter;
    [m_contentControl addSubview:view];
    if(nil == self.superview)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if(nil == window)
        {
            window = [[UIApplication sharedApplication].windows firstObject];
        }
        [window addSubview:self];
    }
}

#pragma mark - 重写setter和getter

-(void)setDelayTime:(NSTimeInterval)delayTime
{
    _delayTime = delayTime;
    if(self.delayTime < 200)
    {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissView) object:nil];
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:self.delayTime];
    }
}

-(void)setBLandscape:(BOOL)bLandscape
{
    BOOL lastState = _bLandscape;
    _bLandscape = bLandscape;
    if(NO == lastState && YES == bLandscape)
    {
        for(UIView *subView in m_contentControl.subviews)
        {
            subView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }
    else if(YES == lastState && NO == bLandscape)
    {
        for(UIView *subView in m_contentControl.subviews)
        {
            subView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
    }
}

@dynamic hadAlert;
-(BOOL)hadAlert
{
    return  nil != self.superview ? YES : NO;
}

#pragma mark - private

-(void)setDismissWhenTap
{
    [m_contentControl addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
}


@end
