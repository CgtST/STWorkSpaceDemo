//
//  CMTableCellScrollDelegate.h
//  ViewTools
//
//  Created by bingo on 16/3/3.
//  Copyright © 2016年 CM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMTableCellScrollDelegate <NSObject>

@required
@property(nonatomic) CGFloat cellOffset;  //滑动偏移量
@property(nonatomic,retain,nullable) UIColor* selBgColor;//选中时的背景颜色

@end
