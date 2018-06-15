//
//  CMAlertViewController.m
//  ViewTools
//
//  Created by bingo on 15/11/13.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMAlertViewController.h"

@interface CMAlertViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,retain) NSMutableArray<__kindof UIView*> *contentView;
@property(nonatomic) CGPoint center;

@end

@implementation CMAlertViewController

-(void)loadView
{
    UIControl* controller = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = controller;
}

-(instancetype)init
{
    self = [super init];
    if(nil != self)
    {
        self.contentView = [NSMutableArray array];
        self.bLandscape = NO;
        self.hideStateBar = NO; //默认为NO
        self.delayTime = 20;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    if(YES == self.bLandscape)
    {
       
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            for(UIView *subView in self.contentView)
            {
                subView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                subView.transform = CGAffineTransformMakeRotation(M_PI_2);
                subView.center = self.center;
            }
        }
        else
        {
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        }
    }
    for(UIView *subView in self.contentView)
    {
        [self.view addSubview:subView];
    }
    
    if(self.delayTime < 200)
    {
        [self performSelector:@selector(dismissController) withObject:nil afterDelay:self.delayTime];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(YES == self.bLandscape &&   [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        for(UIView *subView in self.contentView)
        {
            subView.center = self.center;
        }
    }
}

#pragma mark - public

-(void)dismissController
{
    for(UIView *view in self.view.subviews)
    {
        [view removeFromSuperview];
    }
    self.view.backgroundColor = [UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:^{
     
    }];
}

-(void)addSubView:(nonnull UIView*)subView
{
    if(subView.layer.cornerRadius < 1) //没有圆角是设置圆角
    {
        subView.layer.cornerRadius = 1.5;
    }
    if(nil != subView)
    {
        subView.center = self.center;
        [self.contentView addObject:subView];
    }
}

-(nonnull NSArray<__kindof UIView*>*)showViews; //当前显示的视图
{
    if(nil!= self.view.subviews)
    {
        return self.view.subviews;
    }
    return self.contentView;
}

-(CGPoint)getSubViewCenter
{
    return self.center;
}

-(void)modifyCenter:(CGPoint)centerPt Animation:(BOOL)ani
{
    self.center = centerPt;
    if(NO == ani)
    {
        for(UIView *subView in self.contentView)
        {
            subView.center = self.center;
        }
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^
        {
            for(UIView *subView in self.contentView)
            {
                subView.center = self.center;
            }
        }];
    }
}

-(void)setDismissWhenTap 
{
    UIControl* controller = (UIControl*)self.view;
    [controller addTarget:self action:@selector(touchDismiss) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action

-(void)touchDismiss
{
    [self dismissController];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pt = [gestureRecognizer locationInView:self.view];
    for(UIView *subView in self.view.subviews)
    {
        if(CGRectContainsPoint(subView.frame, pt))
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 重写setter和getter函数

-(void)setDelayTime:(NSTimeInterval)delayTime
{
    _delayTime = delayTime < 1 ? 1 :delayTime;
}

-(void)setBLandscape:(BOOL)bLandscape
{
    _bLandscape = bLandscape;
    if(NO == bLandscape)
    {
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    }
    else
    {
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width/2);
    }
}

#pragma mark - 重载

-(BOOL)prefersStatusBarHidden
{
    return self.hideStateBar;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
