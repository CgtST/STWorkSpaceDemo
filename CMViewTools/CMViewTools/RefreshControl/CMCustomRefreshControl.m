//
//  CMCustomRefreshControl.m
//  ViewTools
//
//  Created by bingo on 15/11/2.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMCustomRefreshControl.h"
#import "CMRefreshControlSubClass.h"


NSString *const CustomRefreshInit = @"CM_global_CMCustomRefreshControl_0";  // 初始化
NSString *const CustomRefreshReady = @"CM_global_CMCustomRefreshControl_1";  //准备刷新
NSString *const CustomRefreshRefreshing = @"CM_global_CMCustomRefreshControl_2"; //正在刷新
NSString *const CustomRefreshEnd = @"CM_global_CMCustomRefreshControl_3"; //刷新完成

@interface CMCustomRefreshControl ()
{
    UILabel *m_textLab;
    UIImageView *m_imageView;
    __unsafe_unretained id m_target;
    SEL m_action;
    NSMutableDictionary *m_textdic;
}

@end

@implementation CMCustomRefreshControl

-(instancetype)init
{
    self = [super initWithHeight:60];
    if(nil != self)
    {
        _refreshHeight = 60;
        m_textLab = [[UILabel alloc] init];
        m_textLab.textColor = [UIColor blackColor]; //默认颜色，可以通过外部设置
        m_textLab.backgroundColor = [UIColor clearColor];
        m_textLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:m_textLab];
        
        m_imageView = [[UIImageView alloc] init];
        m_imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:m_imageView];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.activityIndicatorView];
        
        m_textdic = [[NSMutableDictionary alloc] initWithObjects:@[@"下拉刷新",@"释放刷新",@"更新中……",@"更新完成"] forKeys:@[CustomRefreshInit,CustomRefreshReady,CustomRefreshRefreshing,CustomRefreshEnd]];
        self.imageEdgeInset = UIEdgeInsetsZero;
    }
    return self;
}

#pragma mark - 重载

-(void)refreshStateChanged:(CMRefreshState)refreshState
{
    //更新文本
    NSString *refreshStateKey = [NSString stringWithFormat:@"CM_global_CMCustomRefreshControl_%i",(int)refreshState];
    m_textLab.text = [m_textdic objectForKey:refreshStateKey];
    
    //更新菊花状态
    {
        self.activityIndicatorView.hidden = (CMRefreshStateRefreshing == refreshState) ? NO : YES;
        if(NO == self.activityIndicatorView.hidden)
        {
            [self.activityIndicatorView startAnimating];
        }
        else
        {
            [self.activityIndicatorView stopAnimating];
        }
    }
    
    //更新图片状态
    {
        m_imageView.hidden =  (CMRefreshStateRefreshing == refreshState|| CMRefreshStateEndRefresh == refreshState) ? YES : NO;
        CATransform3D tansform = CATransform3DIdentity;
        if(CMRefreshStateReadyRefresh == refreshState)
        {
            tansform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        }
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        m_imageView.layer.transform = tansform;
        [CATransaction commit];
    }
    
    if(YES == self.bRefresh)
    {
        if(YES == [m_target respondsToSelector:m_action])
        {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"   //消除警告
            __unsafe_unretained CMCustomRefreshControl *refreshControl = self;
            [m_target performSelector:m_action withObject:refreshControl];
        }
    }
}

-(void)updateFrame:(CGRect)frame
{
    if(nil != m_textLab)
    {
        CGFloat imageTop = 5;
        CGFloat imageHeight = 50;
        CGFloat imageWidth = 20;
        CGFloat imageLeftDist = 30; //图片距离左侧距离
        
        if(NO == UIEdgeInsetsEqualToEdgeInsets(self.imageEdgeInset, UIEdgeInsetsZero)) //设置了设置图片范围,修改图片起始位置
        {
            imageTop = self.imageEdgeInset.top;
            imageHeight = frame.size.height - self.imageEdgeInset.top - self.imageEdgeInset.bottom;
            imageLeftDist = self.imageEdgeInset.left;
            imageWidth = frame.size.width -  imageLeftDist - self.imageEdgeInset.right;
            if(imageHeight <=0)
            {
                imageHeight = 50;
                imageTop = 5;
            }
        }

        m_textLab.frame = self.bounds;
        self.activityIndicatorView.frame = CGRectMake(imageLeftDist,(frame.size.height - 20)/2 , 20, 20);
        m_imageView.frame = CGRectMake(imageLeftDist, imageTop, imageWidth, imageHeight);
    }
}

#pragma mark - public

-(void)setText:(NSString*) text forState:(NSString *)customRefreshState
{
    if(nil == text || nil == customRefreshState)
    {
        return;
    }
    [m_textdic setValue:text forKey:customRefreshState];
}

-(void)setTexts:(NSArray<__kindof NSString*>*) textArr forStates:(NSArray<__kindof NSString*> *)stateArr; //设置文本
{
    NSUInteger count = textArr.count > stateArr.count ? stateArr.count : textArr.count;
    for(NSUInteger i = 0; i< count;i++)
    {
        [self setText:[textArr objectAtIndex:i] forState:[stateArr objectAtIndex:i]];
    }
}

-(void) addRefreshingTarget:(id)target action:(SEL)action;
{
    m_target = target;
    m_action = action;
}

-(void)setArrImage:(UIImage *)arrImage
{
    if(nil != arrImage)
    {
        [m_imageView setImage:arrImage];
    }
}


-(void)setTextFont:(UIFont *)textFont
{
    if(nil != textFont)
    {
        m_textLab.font = textFont;
    }
}

-(void)setTextColor:(UIColor *)textColor
{
    if(nil != textColor)
    {
        m_textLab.textColor = textColor;
    }
}


#pragma mark - 重写setter和getter函数

-(void)setImageEdgeInset:(UIEdgeInsets)imageEdgeInset
{
    _imageEdgeInset = imageEdgeInset;
    [self updateFrame:self.frame];
}

@end
