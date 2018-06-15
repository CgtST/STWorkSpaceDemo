//
//  CMScrollTitleView.h
//  ViewTools
//
//  Created by bingo on 15/11/4.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

//可滑动的标题栏
@interface CMScrollTitleView : UIView

@property(nonatomic) NSUInteger selectedIndex; //会触发点击移动事件
@property(nonatomic,retain,nonnull) UIFont *titleFont;  //字体
@property(nonatomic,retain,nonnull) UIColor *titleColor;  //文字颜色
@property(nonatomic,retain,nonnull) UIColor *selectedTitleColor; //选中时的文字颜色

@property(nonatomic,retain,nonnull) NSArray<__kindof NSString*> *titleArray;

//rightFix:右侧固定栏目个数
-(nonnull instancetype)initWithFrame:(CGRect)frame rightFixCount:(NSUInteger)fixCount;

-(void)setSelectedIndex:(NSUInteger)selectedIndex OnClick:(BOOL)bonClick;  //bOnClick表示是否会触发点击事件

-(void)doSelectedAction; //触发选中事件

-(void)setSelectedSignViewColor:(nonnull UIColor*)color; //设置选中时的横线的颜色

-(void)setClick:(nonnull void (^)(NSUInteger clickIndex)) clickblock;

@end
