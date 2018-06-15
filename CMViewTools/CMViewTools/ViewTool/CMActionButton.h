//
//  CMActionButton.h
//  ViewTools
//
//  Created by bingo on 15/11/21.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

//该按钮响应间隔最少为delayTime妙
@interface CMActionButton : UIButton

@property(nonatomic) CGFloat delayTime; //默认为0.25

@end
