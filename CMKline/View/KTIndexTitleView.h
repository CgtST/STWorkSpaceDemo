//
//  KTIndexTitleView.h
//  iBestProduct
//
//  Created by bingo on 2018/6/8.
//  Copyright © 2018年 iBest. All rights reserved.
//


/*
 指标 buttonArray View 
 */


#import <UIKit/UIKit.h>


typedef void(^IndexTitleClickBlock)(NSUInteger index);

@interface KTIndexTitleView : UIView

@property (nonatomic,strong) UIColor * selectedColor; //选中时的字颜色与滑动线颜色一样的
@property (nonatomic,strong) UIColor * moveLineColor; //滑动线颜色
@property (nonatomic,strong) UIColor * bottomLineColor; //底框线颜色

@property (nonatomic) NSUInteger selectIndex; //选中的第几个

/**
 初使化一个IndexTitleView

 @param frame frame description
 @param titles titles description
 @return return value description
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;


//点击了第几个
-(void)clickIndexButtonWithBlock:(IndexTitleClickBlock)block;


@end
