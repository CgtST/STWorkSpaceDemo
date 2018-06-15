//
//  CMAlertViewController.h
//  ViewTools
//
//  Created by bingo on 15/11/13.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>


//最多展示200秒
@interface CMAlertViewController : UIViewController

@property(nonatomic) BOOL bLandscape; //是否为横屏，默认为NO
@property(nonatomic) NSTimeInterval delayTime;
@property(nonatomic) BOOL hideStateBar; //默认为NO
@property(nonatomic) BOOL hadAlert; //是否已经弹框

-(void)dismissController;

-(void)addSubView:(nonnull UIView*)subView;

-(nonnull NSArray<__kindof UIView*>*)showViews; //当前显示的视图

-(CGPoint)getSubViewCenter;

-(void)modifyCenter:(CGPoint)centerPt Animation:(BOOL)ani;

-(void)setDismissWhenTap; 


@end
