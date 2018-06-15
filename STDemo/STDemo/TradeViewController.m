//
//  TradeViewController.m
//  STDemo
//
//  Created by bingo on 2018/6/15.
//  Copyright © 2018年 bingo. All rights reserved.
//

#import "TradeViewController.h"

@interface TradeViewController ()

@end

@implementation TradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
 self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
