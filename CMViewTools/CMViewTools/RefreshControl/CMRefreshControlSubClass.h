//
//  CMRefreshControlSubClass.h
//  ViewTools
//
//  Created by bingo on 15/11/2.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMRefreshControl.h"

typedef NS_ENUM(NSUInteger, CMRefreshState)
{
    CMRefreshStateInit = 0,         //开始显示的时候
    CMRefreshStateReadyRefresh, //准备刷新的时候(超过拉动的距离，但是在松开手指之前)
    CMRefreshStateRefreshing,     //正在刷新的时候（松开手指的时候，该状态始终在BeginRefresh状态之后）
    CMRefreshStateEndRefresh,     //结束刷新的时候
};

@interface CMRefreshControl(CMRefreshControlProtected)

-(nonnull instancetype)initWithHeight:(CGFloat)height;

-(void)updateFrame:(CGRect)frame;

-(void)refreshStateChanged:(CMRefreshState)refreshState; //状态改变时

-(void)setcanRefresh:(BOOL)canRefresh;//是否能够刷新

@end
