//
//  OneViewController.m
//  STDemo
//
//  Created by bingo on 2018/6/15.
//  Copyright © 2018年 bingo. All rights reserved.
//

#import "OneViewController.h"
#import "TwoViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    UIButton * oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 90, 50)];
    oneBtn.backgroundColor = [UIColor purpleColor];
    [oneBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oneBtn];
    
}


-(void)click:(UIButton *)sender
{
    TwoViewController * oneVC = [[TwoViewController alloc] init];
    [self.rt_navigationController pushViewController:oneVC animated:YES];
    
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
