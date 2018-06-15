//
//  CMAlertMsgShowView.h
//  ViewTools
//
//  Created by bingo on 16/1/6.
//  Copyright © 2016年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMAlertMsgShowView : UIView

-(nonnull instancetype)initWithContent:(nonnull NSString*)contentStr;

-(void)setContentTextColor:(nonnull UIColor*)contentColor;

-(void)setContentFont:(nonnull UIFont*)font;

@end
