//
//  UIButton+QNAdditions.h
//  QNPhoneNiuNiu
//
//  Created by 米饭 on 13-9-12.
//  Copyright (c) 2013年 Manny_at_futu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EasySet)

- (id)setTitle:(NSString *)title backgroundImage:(NSString *)imageName;

- (id)setTitleColor:(UIColor *)color backgroundImage:(NSString *)imageName;

- (id)setTitleColor:(UIColor *)color highlightedColor:(UIColor *)hlColor;

- (id)setImage:(NSString *)imageName highlightedImage:(NSString *)hlImageName;

@end
