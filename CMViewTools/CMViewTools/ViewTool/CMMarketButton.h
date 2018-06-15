//
//  CMMarketButton.h
//  ViewTools
//
//  Created by bingo on 15/11/5.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

//三个大色块对应的按钮
@interface CMMarketButton : UIButton

@property(nonatomic,copy,nonnull) NSString *merchCode;  //代码
@property(nonatomic) NSInteger iMarket;  //市场类型
@property(nonatomic,readonly,nonnull) UILabel *nameLabel;  //名称
@property(nonatomic,readonly,nonnull) UILabel *newestPriceLab; //最新价
@property(nonatomic,readonly,nonnull) UILabel *risePricePresentLab; //涨幅

//是否为同一商品
-(BOOL)isSameMerch:(nonnull NSString *)stockCode andMarket:(NSInteger)market;

-(void)setFontColor:(nonnull UIColor*)color;

-(void)clearData;

@end
