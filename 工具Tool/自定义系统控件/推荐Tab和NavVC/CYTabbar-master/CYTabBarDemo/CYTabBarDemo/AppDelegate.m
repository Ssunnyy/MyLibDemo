//
//  AppDelegate.m
//  CYTabBarDemo
//
//  Created by 张春雨 on 2017/3/12.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "CYTabBarController.h"

#define statues 1
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    CYTabBarController * tabbar = [[CYTabBarController alloc]init];
    
    
    /**
     *  配置外观
     */
    [CYTabBarConfig shared].selectedTextColor = [UIColor orangeColor];
//    [CYTabBarConfig shared].textColor = [UIColor redColor];
//    [CYTabBarConfig shared].backgroundColor = [UIColor greenColor];
    [CYTabBarConfig shared].selectIndex = 0;
    
    
    if (statues == 1) {
        
        /**
         *  style 1 (中间按钮突出 ， 设为按钮 , 底部有文字 ， 闲鱼)
         */
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
        [tabbar addChildController:nav1 title:@"发现" imageName:@"Btn01" selectedImageName:@"SelectBtn01"];
        UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
        [tabbar addChildController:nav2 title:@"我的" imageName:@"Btn02" selectedImageName:@"SelectBtn02"];
        [tabbar addCenterController:nil bulge:YES title:@"发布" imageName:@"post_normal" selectedImageName:@"bc"];
    } else if (statues == 2) {
        /**
         *  style 2  (中间按钮突出 ， 设为控制器 ,底部有文字 )
         */
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
        [tabbar addChildController:nav1 title:@"消息" imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
        UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController2 new]];
        [tabbar addChildController:nav2 title:@"朋友圈" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
        UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:[ViewController3 new]];
        [tabbar addCenterController:nav3 bulge:YES title:@"发布" imageName:@"post_normal" selectedImageName:@"bc"];
    } else if (statues == 3) {
        /**
         *  style 3  (中间按钮不突出 ， 设为按钮 ,底部无文字  , 微博)
         */
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
        [tabbar addChildController:nav1 title:@"消息" imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
        UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController2 new]];
        [tabbar addChildController:nav2 title:@"朋友圈" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
        [tabbar addCenterController:nil bulge:NO title:nil imageName:@"tabbar_centerplus_selected" selectedImageName:@"tabbar_centerplus_selected"];
    } else if (statues == 4) {
        /**
         *  style 4  (中间按钮不突出 ， 设为控制器 ,底部无文字  , 微博)
         */
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
        [tabbar addChildController:nav1 title:@"消息" imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
        UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController2 new]];
        [tabbar addChildController:nav2 title:@"朋友圈" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
        UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:[ViewController3 new]];
        [tabbar addCenterController:nav3 bulge:NO title:nil imageName:@"tabbar_centerplus_selected" selectedImageName:@"tabbar_centerplus_selected"];
    } else if (statues == 5) {
        /**
         *  style 5  (无中间按钮 ，普通样式)
         */
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
        [tabbar addChildController:nav1 title:@"消息" imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
        UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
        [tabbar addChildController:nav2 title:@"朋友圈" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
    }
    
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
