//
//  CMRefreshControl.m
//  ViewTools
//
//  Created by bingo on 15/11/2.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMRefreshControl.h"
#import "CMRefreshControlSubClass.h"


typedef void (^TimeOutBlock)(void);

@interface CMRefreshControl ()
{
    TimeOutBlock m_timeOutBlock;
}
@property(nonatomic,readonly) CGFloat viewHeight;  //视图高度
@property(nonatomic,readwrite) CMRefreshState refreshState;
@property(nonatomic,readonly) BOOL bEnableRefresh;  //是否能够进行刷新;
@end

@implementation CMRefreshControl


-(instancetype)init
{
    return [self initWithHeight:100];
}


#pragma mark - public

-(void)endRefresh
{
    self.refreshState = CMRefreshStateEndRefresh;
    __weak UIScrollView *scrollview = [self getScrollView];
    if(nil != scrollview)
    {
        [UIView animateWithDuration:0.15 animations:^
         {
             scrollview.contentInset = UIEdgeInsetsZero;
             scrollview.contentOffset = CGPointZero;
         }];
    }
}

//设置超时block
-(void)setTimeOutRefreshBlock:(void (^)(void))timeOutBlock
{
    m_timeOutBlock = timeOutBlock;
}

#pragma mark - 重载UIView的函数

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if(nil == newSuperview && [self.superview isKindOfClass:[UIScrollView class]])  //从UIcrollView中移除
    {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
        [self.superview removeObserver:self forKeyPath:@"contentSize"];
    }
    else if(nil != newSuperview && YES == [newSuperview isKindOfClass:[UIScrollView class]])  //添加到UIcrollView中
    {
        [((UIScrollView*)newSuperview) addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL ];
        [((UIScrollView*)newSuperview) addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
}

-(void)didMoveToSuperview
{
    if(nil != self.superview)
    {
        [self updateFrame];
        [self.superview sendSubviewToBack:self];   //将该视图放在最后面
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(NO == [object isKindOfClass:[UIScrollView class]])
    {
        return;
    }
    if(YES == [keyPath isEqualToString:@"contentOffset"])
    {
        if(NO == self.bEnableRefresh || CMRefreshStateRefreshing == self.refreshState)
        {
            return;
        }
        CGPoint point = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        self.refreshState = [self getState:point];
        if(CMRefreshStateRefreshing == self.refreshState)
        {
            [self setContentInsetWhenRefreshing];
        }
    }
    else if(YES == [keyPath isEqualToString:@"contentSize"])
    {
        if(CMRefreshDirectionPullUp == self.refreshDirction)
        {
            [self updateFrame];
        }
    }
}


#pragma mark - private

-(CGFloat)getMinOffsetWhenPullUp //上拉刷新的最小移动距离
{
    UIScrollView *scrollView = [self getScrollView];
    CGFloat minOffset = scrollView.contentSize.height - scrollView.bounds.size.height;
    minOffset = minOffset > 0 ? minOffset : 0;
    return minOffset;
}

-(UIScrollView*)getScrollView
{
    if(YES == [self.superview isKindOfClass:[UIScrollView class]])
    {
        return (UIScrollView*)self.superview;
    }
    return nil;
}

//正处在刷新时，设置内容偏移
-(void)setContentInsetWhenRefreshing
{
    UIEdgeInsets edgeInset = UIEdgeInsetsZero;
    if(CMRefreshDirectionPullDown == self.refreshDirction)
    {
        edgeInset = UIEdgeInsetsMake(self.viewHeight, 0, 0, 0);
    }
    else if(CMRefreshDirectionPullUp == self.refreshDirction)
    {
        UIScrollView *scrollview = (UIScrollView*)self.superview;
        float height=MIN(scrollview.contentSize.height, scrollview.frame.size.height);
        edgeInset = UIEdgeInsetsMake(0, 0, scrollview.bounds.size.height + self.viewHeight - height, 0);
    }
    UIScrollView *scrollview = [self getScrollView];
    [UIView animateWithDuration:0.5 animations:^
     {
         scrollview.contentInset = edgeInset;
     }];
}

-(void)updateFrame
{
    if(CMRefreshDirectionPullDown == self.refreshDirction)
    {
        super.frame = CGRectMake(0, -self.viewHeight, self.superview.bounds.size.width, self.viewHeight);
        [self updateFrame:self.frame];
    }
    else if(CMRefreshDirectionPullUp == self.refreshDirction)
    {
        UIScrollView *scrollview = [self getScrollView];
        float height=MAX(scrollview.contentSize.height, scrollview.frame.size.height);
        super.frame = CGRectMake(0, height, self.superview.bounds.size.width, self.viewHeight);
        [self updateFrame:self.frame];
    }
}


-(CMRefreshState)getState:(CGPoint)offset
{
    if(CMRefreshDirectionPullDown ==self.refreshDirction && offset.y > 0) //下拉刷新控件，上拉刷新操作
    {
        return CMRefreshStateInit;
    }
    if(CMRefreshDirectionPullUp == self.refreshDirction
       && offset.y < [self getMinOffsetWhenPullUp])  //上拉刷新控件,下拉刷新操作或者上拉的距离不够
    {
        return CMRefreshStateInit;
    }
    
    if((CMRefreshDirectionPullDown == self.refreshDirction && offset.y <= 0) //下拉刷新
       || (CMRefreshDirectionPullUp == self.refreshDirction && offset.y >= 0)) //上拉刷新
    {
        CGFloat ypos = fabs(offset.y);
        UIScrollView *scrollView = [self getScrollView];
        if(CMRefreshDirectionPullUp == self.refreshDirction && offset.y >= 0) //上拉刷新
        {
            ypos = offset.y - [self getMinOffsetWhenPullUp];
        }
        if(YES == scrollView.dragging) //拖拽时
        {
            return ypos < self.viewHeight ? CMRefreshStateInit : CMRefreshStateReadyRefresh;
        }
        else if(CMRefreshStateReadyRefresh == self.refreshState) //开始刷新状态时(并且已经结束了拖拽)
        {
            return CMRefreshStateRefreshing;
        }
        else
        {
            return CMRefreshStateEndRefresh;
        }
    }
    return CMRefreshStateInit;
}

-(void)becomeEndRefresh
{
    if(YES == self.bRefresh)
    {
        [self endRefresh];
        if(nil != m_timeOutBlock)
        {
            m_timeOutBlock();
        }
    }
}


#pragma mark - 重写setter和getter函数

-(void)setFrame:(CGRect)frame
{
    //禁止设置frame大小
}

@synthesize viewHeight = _viewHeight;
@synthesize refreshState = _refreshState;
@synthesize refreshDirction = _refreshDirction;

-(void)setRefreshDirction:(CMRefreshDirection)refreshDirction
{
    _refreshDirction = refreshDirction;
    if(nil != self.superview && YES == [self.superview isKindOfClass:[UIScrollView class]])
    {
        [self updateFrame];
    }
}

-(void)setRefreshState:(CMRefreshState)refreshState
{
    CMRefreshState lastRefreshState = self.refreshState;
    _refreshState = refreshState;
    _bRefresh = CMRefreshStateRefreshing == self.refreshState ? YES : NO;
    //状态改变时
    if(lastRefreshState != self.refreshState)
    {
        [self refreshStateChanged:refreshState];
    }
    if(YES == self.bRefresh)
    {
        [self performSelector:@selector(becomeEndRefresh) withObject:nil afterDelay:self.timeOutLimit];
    }
}


@end
