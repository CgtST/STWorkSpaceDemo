//
//  IBTopLabel.h
//  QNApp
//
//  Created by Baicai on 2017/4/8.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,VerticalAlignment)
{
      VerticalAlignmentTop = 0, // default
      VerticalAlignmentMiddle,
      VerticalAlignmentBottom,
};

@interface IBTopLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
