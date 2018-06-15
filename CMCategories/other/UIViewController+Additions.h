//
//  UIViewController+Additions.h
//  QNEngine
//
//  Created by tj on 12/18/15.
//  Copyright © 2015 Bacai. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIViewController (Additions)
/**
 * 关闭当前ViewController,不管是模态推出还是Push方式。注意：未经过大规模测试，目前测试过几个界面未发现问题。
 */
- (void)finishViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;

/**
 * 判断当前窗口是否以模态方式推出。注意：未经过大规模测试，目前测试过几个界面未发现问题。
 */
- (BOOL) isModal;
@end
