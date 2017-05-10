//
//  ViewController2.m
//  CYNavigationDemo
//
//  Created by 张春雨 on 2017/5/6.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "ViewController2.h"
#import "CYNavigationController.h"

@interface ViewController2 ()

@end

@implementation ViewController2

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavgation];
}

#pragma mark - 设置导航栏
- (void)setNavgation{
    self.navigationbar = [self standardNavigationbar];
    self.navigationbar.backgroundColor = [UIColor whiteColor];
    [CYNavigationConfig shared].fontColor = [UIColor blackColor];
    [CYNavigationConfig shared].leftBtnImageColor = [UIColor blackColor];
    self.navigationbar.title.text = @"子页";
    [self.navigationbar.leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationbar.rightBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [self.navigationbar.rightBtn addTarget:self action:@selector(next) forControlEvents:
     UIControlEventTouchUpInside];
}

- (void)next{
    ViewController2 *vc = [[ViewController2 alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
