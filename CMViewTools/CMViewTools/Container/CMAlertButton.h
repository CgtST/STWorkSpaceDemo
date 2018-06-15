//
//  CMAlertButton.h
//  ViewTools
//
//  Created by bingo on 16/1/6.
//  Copyright © 2016年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMAlertButton : UIButton

-(void)setDismissBlock:(void (^)(void)) dimissblock;

@end
