//
//  STTabBarViewController.m
//  STDemo
//
//  Created by bingo on 2018/6/15.
//  Copyright © 2018年 bingo. All rights reserved.
//

#import "STTabBarViewController.h"
#import "UIColor+HexString.h"
#import "RTRootNavigationController.h"

#import "HomeViewController.h"
#import "QuoteViewController.h"
#import "TradeViewController.h"
#import "NewsViewController.h"


@interface STTabBarViewController ()

@property(nonatomic,readonly,retain,nonnull)RTRootNavigationController * homeMainNavController;
@property(nonatomic,readonly,retain,nonnull)RTRootNavigationController * quoteMainNavController;
@property(nonatomic,readonly,retain,nonnull)RTRootNavigationController * tradeMainNavController;
@property(nonatomic,readonly,retain,nonnull)RTRootNavigationController * inforMainNavController;


@end



@implementation STTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewControllers = @[self.homeMainNavController,self.quoteMainNavController,self.tradeMainNavController,self.inforMainNavController];
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



#pragma mark - 导航控制器相关(private)
-(NSDictionary*)navTextAttributesWithState:(UIControlState)state
{
    if(UIControlStateSelected == state)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"#fc6131"],NSForegroundColorAttributeName,nil];
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName,nil];
    }
}

-(void)setImage:(nonnull UIImage*)normalImage andSelectedImage:(nonnull UIImage*)selectedImage toNavigationController:(nonnull UINavigationController*)navController
{
    //设置tabBar标签栏颜色和字体
    [navController.tabBarItem setTitleTextAttributes:[self navTextAttributesWithState:UIControlStateNormal] forState:UIControlStateNormal];
    [navController.tabBarItem setTitleTextAttributes:[self navTextAttributesWithState:UIControlStateSelected]forState:UIControlStateSelected];
    
    UIOffset offset=navController.tabBarItem.titlePositionAdjustment;
    offset.vertical= 1;
    [navController.tabBarItem setTitlePositionAdjustment:offset];
    
    navController.tabBarItem.image=[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navController.tabBarItem.selectedImage=[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置导航栏颜色和字体
    [navController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    
    
}




#pragma mark - getter and setter

//首页
@synthesize homeMainNavController = _homeMainNavController;
-(UINavigationController *)homeMainNavController {
    if (nil == _homeMainNavController) {
        HomeViewController * vc = [[HomeViewController alloc] init];
        
        _homeMainNavController =   [[RTRootNavigationController alloc] initWithRootViewController:vc];
        
        _homeMainNavController.tabBarItem.title = @"首页";
        
        [self setImage:[UIImage imageNamed: @"home_icon"]  andSelectedImage:[UIImage imageNamed: @"home_selected"] toNavigationController:_homeMainNavController ];
        
    }
    return _homeMainNavController;
}


//行情
@synthesize quoteMainNavController = _quoteMainNavController;
-(UINavigationController *)quoteMainNavController
{
    if (nil == _quoteMainNavController)
    {
        QuoteViewController * vc = [[QuoteViewController alloc] init];
        _quoteMainNavController = [[RTRootNavigationController alloc] initWithRootViewController:vc];
        _quoteMainNavController.tabBarItem.title = @"行情";
       
        [self setImage:[UIImage imageNamed:@"quote_icon"] andSelectedImage:[UIImage imageNamed:@"quote_selected"] toNavigationController:_quoteMainNavController ];
        
    }
    return _quoteMainNavController;
}

//交易
@synthesize tradeMainNavController = _tradeMainNavController;
-(UINavigationController *)tradeMainNavController
{
    
    if (nil == _tradeMainNavController)
    {
        
        TradeViewController * vc =  [[TradeViewController alloc] init];
        _tradeMainNavController = [[RTRootNavigationController alloc] initWithRootViewController:vc];
        _tradeMainNavController.tabBarItem.title = @"交易";
    
        [self setImage:[UIImage imageNamed:@"trade_icon"] andSelectedImage:[UIImage imageNamed:@"trade_selected"] toNavigationController:_tradeMainNavController];
        
        
    }
    return _tradeMainNavController;
}


//资讯
@synthesize inforMainNavController = _inforMainNavController;
-(UINavigationController *)inforMainNavController
{
    if (nil == _inforMainNavController)
    {
        NewsViewController * vc =  [[NewsViewController alloc] init];
       
        _inforMainNavController = [[RTRootNavigationController alloc] initWithRootViewController:vc];
        _inforMainNavController.tabBarItem.title = @"资讯";
        [self setImage:[UIImage imageNamed:@"news_icon"] andSelectedImage:[UIImage imageNamed:@"news_selected"] toNavigationController:_inforMainNavController ];
        
    }
    return _inforMainNavController;
}



@end
