//
//  CMRefreshControl.h
//  ViewTools
//
//  Created by bingo on 15/11/2.
//  Copyright © 2015年 CM. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CMRefreshControl.h"

typedef  NS_ENUM(NSUInteger, CMRefreshDirection)
{
    CMRefreshDirectionPullDown,  //下拉刷新
    CMRefreshDirectionPullUp,    //上拉刷新
};

//滚动视图下拉刷新。
@interface CMRefreshControl : UIView

@property(nonatomic) NSTimeInterval timeOutLimit; //超时限制，默认为30秒
@property(nonatomic) CMRefreshDirection refreshDirction;
@property(nonatomic,readonly,getter=isRefreshing) BOOL bRefresh;  //是否正在刷新

-(void)endRefresh;

//设置超时block
-(void)setTimeOutRefreshBlock:(void (^)(void))timeOutBlock;

@end
