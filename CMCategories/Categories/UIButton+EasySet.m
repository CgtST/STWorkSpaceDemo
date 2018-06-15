//
//  UIButton+QNAdditions.m
//  QNPhoneNiuNiu
//
//  Created by 米饭 on 13-9-12.
//  Copyright (c) 2013年 Manny_at_futu.cn. All rights reserved.
//

#import "UIButton+EasySet.h"
#import "ThemeManager.h"

@implementation UIButton (EasySet)

- (id)setTitle:(NSString *)title backgroundImage:(NSString *)imageName
{
    [self setTitle: title forState: UIControlStateNormal];
    UIImage *image = [[Theme() getThemeImage: imageName] stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
    [self setBackgroundImage: image forState: UIControlStateNormal];
    
    return self;
}

- (id)setTitleColor:(UIColor *)color backgroundImage:(NSString *)imageName
{
    [self setTitleColor: color forState: UIControlStateNormal];
    UIImage *image = [[Theme() getThemeImage: imageName] stretchableImageWithLeftCapWidth: 5 topCapHeight:5];
    [self setBackgroundImage: image forState: UIControlStateNormal];
    
    return self;
}

- (id)setTitleColor:(UIColor *)color highlightedColor:(UIColor *)hlColor
{
    [self setTitleColor: color forState: UIControlStateNormal];
    [self setTitleColor: hlColor forState: UIControlStateHighlighted];
    
    return self;
}

- (id)setImage:(NSString *)imageName highlightedImage:(NSString *)hlImageName
{
    UIImage *normalImage = [[Theme() getThemeImage: imageName] stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
    UIImage *hlImage = [[Theme() getThemeImage: hlImageName] stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
    [self setBackgroundImage: normalImage forState: UIControlStateNormal];
    [self setBackgroundImage: hlImage forState: UIControlStateHighlighted];
    return self;
}

@end
