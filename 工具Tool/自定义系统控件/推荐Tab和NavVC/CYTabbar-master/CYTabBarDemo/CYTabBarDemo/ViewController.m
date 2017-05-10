//
//  ViewController.m
//  CYTabBarDemo
//
//  Created by 张春雨 on 2017/3/12.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "ViewController.h"
#import "PlusAnimate.h"
#import "CYTabBarController.h"
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDelegate , CYTabBarDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = self.tabBarItem.title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width-150)/2;
    UIButton *btn  = [[UIButton alloc]initWithFrame:CGRectMake(x, 200, 150, 30)];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    

    UIButton *btn1  = [[UIButton alloc]initWithFrame:CGRectMake(x, 300, 150, 30)];
    [btn1 setTitle:@"隐藏或显示tabbar" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    CYTABBARCONTROLLER.tabbar.delegate = self;
    self.tabBarItem.badgeValue = @"remind";
}


#pragma mark - CYTabBarDelegate
//中间按钮点击
- (void)tabbar:(CYTabBar *)tabbar clickForCenterButton:(CYCenterButton *)centerButton{
    [PlusAnimate standardPublishAnimateWithView:centerButton];
}
//是否允许切换
- (BOOL)tabBar:(CYTabBar *)tabBar willSelectIndex:(NSInteger)index{
    NSLog(@"将要切换到---> %ld",index);
    return YES;
}
//通知切换的下表
- (void)tabBar:(CYTabBar *)tabBar didSelectIndex:(NSInteger)index{
    NSLog(@"切换到---> %ld",index);
}




#pragma mark - 跳转页面
- (void)btnClick{
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 隐藏tabbar
- (void)hidden{
    [CYTABBARCONTROLLER setCYTabBarHidden:!CYTABBARCONTROLLER.tabbar.hidden animated:YES];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static int i= 0;
    NSLog(@"touchesBegan %d",i++);
}

@end
