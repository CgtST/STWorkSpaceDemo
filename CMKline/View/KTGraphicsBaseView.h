//
//  KTGraphicsBaseView.h
//  iBestProduct
//
//  Created by bingo on 2018/6/8.
//  Copyright © 2018年 iBest. All rights reserved.
//



/*
 表格布局基类:由它定义主副图布局（统一格式）
 */


#import <UIKit/UIKit.h>

@interface KTGraphicsBaseView : UIView


@property (nonatomic,strong) UIFont * textFont;  //画文本大小

- (CGRect)gridRect; //网格线区域

- (CGRect)dataRect; //数据区域

- (CGRect)leftStringRect; //左边文本区域

- (CGRect)buttomStringRect;  //底部文本区域

- (CGRect)rightStringRect; //右边文本区域

- (CGRect)volumeGridRect; //副图网格区域

//量线数据区域
- (CGRect)volumeDataRect;  //副图数据区域



//在数据区左右文字
- (void)drawString:(CGRect)rect stringList:(NSArray *)list lOrR:(bool)lr;




@end
