//
//  CM2ButtonAlertView.h
//  ViewTools
//
//  Created by bingo on 15/11/16.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CM2ButtonAlertView : UIView

-(nonnull instancetype)initWithTitle:(nullable NSString*)title Content:(nonnull NSString*)contentStr ;

@property(nonatomic,readonly,retain,nullable) UILabel *titleLab;
@property(nonatomic,readonly,retain,nonnull) UILabel *contentLab;
@property(nonatomic,readonly,retain,nonnull) UIButton *sureButton;
@property(nonatomic,readonly,retain,nonnull) UIButton *cancleButton;  //取消按钮

@property(nonatomic,retain,nonnull) UIColor *sepColor; //分割线颜色

@end
