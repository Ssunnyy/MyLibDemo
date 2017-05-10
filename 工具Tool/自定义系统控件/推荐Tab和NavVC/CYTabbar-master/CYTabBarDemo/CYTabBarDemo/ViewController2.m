//
//  ViewController2.m
//  CYTabBarDemo
//
//  Created by 张春雨 on 2017/3/13.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "ViewController2.h"
#import "CYTabBar.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarItem.badgeColor = [UIColor orangeColor];
    self.tabBarItem.badgeValue = @"1234";
    
    self.navigationItem.title = @"朋友圈";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
