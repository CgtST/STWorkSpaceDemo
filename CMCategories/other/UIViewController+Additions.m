//
//  UIViewController+Additions.m
//  QNEngine
//
//  Created by tj on 12/18/15.
//  Copyright © 2015 Bacai. All rights reserved.
//

#import "UIViewController+Additions.h"


@implementation UIViewController (Additions)

- (void)finishViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    if ([self isModal]) {
        [self dismissViewControllerAnimated:flag completion:completion];
    } else {
        [self.navigationController popViewControllerAnimated:flag];
        completion();
    }
}

- (BOOL) isModal {
    return self.presentingViewController.presentedViewController == self
    || (self.navigationController != nil && self.navigationController.presentingViewController.presentedViewController == self.navigationController &&
        [self.navigationController.viewControllers indexOfObject:self] == 0
        )
    || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}
@end
