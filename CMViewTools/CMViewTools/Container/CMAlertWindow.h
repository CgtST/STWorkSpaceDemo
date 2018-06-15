//
//  CMAlertWindow.h
//  ViewTools
//
//  Created by bingo on 15/11/5.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

//将CMAlertWindow添加到当前window上
@interface CMAlertWindow : UIView

@property(nonatomic) BOOL bLandscape; //是否为横屏，默认为NO
@property(nonatomic) NSTimeInterval delayTime;
@property(nonatomic,readonly) BOOL hadAlert; //是否已经弹框
@property(nonatomic,retain,nonnull) UIColor *alertMaskColor; //蒙版颜色

+ (nonnull instancetype)shared;

-(CGPoint)getSubViewCenter;

-(void)modifyCenter:(CGPoint)centerPt Animation:(BOOL)ani;

-(CGPoint)getAlertCenter;

-(void)dismissView;

-(void)setDismissWhenTap;

@end
