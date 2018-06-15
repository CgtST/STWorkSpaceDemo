//
//  CMCustomRefreshControl.h
//  ViewTools
//
//  Created by bingo on 15/11/2.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMRefreshControl.h"

UIKIT_EXTERN NSString *const CustomRefreshInit;  // 初始化
UIKIT_EXTERN NSString *const CustomRefreshReady;  //准备刷新
UIKIT_EXTERN NSString *const CustomRefreshRefreshing; //正在刷新
UIKIT_EXTERN NSString *const CustomRefreshEnd; //刷新完成

@interface CMCustomRefreshControl : CMRefreshControl

@property(nonatomic,readonly) UIActivityIndicatorView *activityIndicatorView; //菊花
@property(nonatomic) UIEdgeInsets imageEdgeInset;  //图片的位置
@property(nonatomic,readonly) CGFloat refreshHeight;

-(void)setArrImage:(UIImage *)arrImage; //刷新时的箭头图片

-(void)setTextFont:(UIFont *)textFont; //字体

-(void)setTextColor:(UIColor *)textColor;//字体颜色


-(void)setText:(NSString*) text forState:(NSString *)customRefreshState; //设置文本

-(void)setTexts:(NSArray<__kindof NSString*>*) textArr forStates:(NSArray<__kindof NSString*> *)stateArr; //设置文本

-(void) addRefreshingTarget:(id)target action:(SEL)action;


@end
