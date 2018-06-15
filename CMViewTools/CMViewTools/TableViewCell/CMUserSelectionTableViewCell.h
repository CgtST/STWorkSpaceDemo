//
//  CMUserSelectionTableViewCell.h
//  ViewTools
//
//  Created by bingo on 15/11/3.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

//自选单元格
@interface CMUserSelectionTableViewCell : UITableViewCell

@property(nonatomic,copy,nonnull) NSString *merchCode;  //代码
@property(nonatomic) NSInteger iMarket;  //市场类型
@property(nonatomic) UIEdgeInsets buttonEdgeInset;

//colWidths存放的是列的宽度。其中第一列表示距离屏幕左侧的间隔。colWidths默认为4个数值
-(nonnull instancetype)initWithcolWidths:(nonnull NSArray<__kindof NSNumber*>*)colWidths reuseIdentifier:(nonnull NSString*)reuseIdentifier;

//是否为同一商品
-(BOOL)isSameMerch:(nonnull NSString *)stockCode andMarket:(NSInteger)market;

#pragma mark - 属性

-(void)setContentFont:(nonnull UIFont*)font;  //设置字体

-(void)setContentTextColor:(nonnull UIColor*)textColor; //设置字体颜色

-(void)setRiseValueTextColor:(nonnull UIColor*)riseValueColor;  //设置第三列的字体颜色

-(void)setSelectedBackgroundColor:(nonnull UIColor*)bgColor;//设置选中时的背景颜色

-(void)setSepLineColor:(nonnull UIColor*)sepColor;//设置分割线的颜色

#pragma mark - 功能

//为第三列 添加点击事件
- (void)addTarget:(nullable id)target action:(nullable SEL)action;

//设置商品名称
-(void)setMerchName:(nonnull NSString*)merchName;

//设置最新价
-(void)setNewPrice:(nonnull NSString*)newPrice;

//设置涨幅等和背景颜色
-(void)setRiseValue:(nonnull NSString*)value withBackColor:(nonnull UIColor*)backgroundColor;


@end
